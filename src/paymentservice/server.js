// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

const path = require('path');
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const charge = require('./charge');

const logger = require('./logger')
const processedPayments = new Map();

const { createClient } = require('redis');
const crypto = require('crypto');

const redisClient = createClient({
  url: process.env.REDIS_ADDR || 'redis://redis-payment:6379',
});

redisClient.on('error', (err) => {
  logger.error(`Redis error: ${err}`);
});

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

class HipsterShopServer {
  constructor(protoRoot, port = HipsterShopServer.PORT) {
    this.port = port;

    this.packages = {
      hipsterShop: this.loadProto(path.join(protoRoot, 'demo.proto')),
      health: this.loadProto(path.join(protoRoot, 'grpc/health/v1/health.proto'))
    };

    this.server = new grpc.Server();
    this.loadAllProtos(protoRoot);
  }

  /**
   * Handler for PaymentService.Charge.
   * @param {*} call  { ChargeRequest }
   * @param {*} callback  fn(err, ChargeResponse)
   */
  static async ChargeServiceHandler(call, callback) {
    const idempotencyKey = call.request.idempotency_key;

    if (!idempotencyKey) {
      const err = new Error('idempotency_key is required');
      err.code = grpc.status.INVALID_ARGUMENT;
      callback(err);
      return;
    }

    const resultKey = `payment:idempotency:${idempotencyKey}`;
    const lockKey = `payment:idempotency:lock:${idempotencyKey}`;

    // このリクエストだけが知っているlock owner ID
    const lockToken = crypto.randomUUID();

    try {
      logger.info(
        `PaymentService#Charge invoked with idempotency_key=${idempotencyKey}`
      );

      // 1. すでに決済済みなら即座に前回結果を返す
      const cached = await redisClient.get(resultKey);

      if (cached) {
        logger.info(
          `Duplicate payment detected. Returning cached response: ${idempotencyKey}`
        );

        callback(null, JSON.parse(cached));
        return;
      }

      // 2. lock取得
      // NX = keyが存在しない場合のみSET
      // EX = lockの自動有効期限
      const acquired = await redisClient.set(
        lockKey,
        lockToken,
        {
          NX: true,
          EX: 30,
        }
      );

      // 3. 別Podが処理中
      if (!acquired) {
        logger.info(
          `Payment already processing: ${idempotencyKey}`
        );

        // 最大5秒ほど結果を待つ
        for (let i = 0; i < 50; i++) {
          await sleep(100);

          const result = await redisClient.get(resultKey);

          if (result) {
            logger.info(
              `Payment result became available: ${idempotencyKey}`
            );

            callback(null, JSON.parse(result));
            return;
          }
        }

        const err = new Error('payment is still being processed');
        err.code = grpc.status.UNAVAILABLE;
        callback(err);
        return;
      }

      // 4. lock取得成功したPodだけ実際の決済処理
      logger.info(
        `Payment lock acquired: ${idempotencyKey}`
      );

      const response = charge(call.request);

      // 5. 結果保存
      await redisClient.set(
        resultKey,
        JSON.stringify(response),
        {
          EX: 3600,
        }
      );

      logger.info(
        `Payment processed and cached in Redis: ${idempotencyKey}`
      );

      callback(null, response);

    } catch (err) {
      console.warn(err);
      callback(err);

    } finally {
      // lockを持っている本人だけ削除する
      const releaseLockScript = `
        if redis.call("GET", KEYS[1]) == ARGV[1] then
          return redis.call("DEL", KEYS[1])
        else
          return 0
        end
      `;

      try {
        await redisClient.eval(releaseLockScript, {
          keys: [lockKey],
          arguments: [lockToken],
        });
      } catch (err) {
        logger.error(
          `Failed to release payment lock: ${err}`
        );
      }
    }
  }

  static CheckHandler(call, callback) {
    callback(null, { status: 'SERVING' });
  }

  async listen() {
    await redisClient.connect();
    logger.info('Connected to payment Redis');
    const server = this.server;
    const port = this.port;
    server.bindAsync(
      `[::]:${port}`,
      grpc.ServerCredentials.createInsecure(),
      function () {
        logger.info(`PaymentService gRPC server started on port ${port}`);
        server.start();
      }
    );
  }

  loadProto(path) {
    const packageDefinition = protoLoader.loadSync(
      path,
      {
        keepCase: true,
        longs: String,
        enums: String,
        defaults: true,
        oneofs: true
      }
    );
    return grpc.loadPackageDefinition(packageDefinition);
  }

  loadAllProtos(protoRoot) {
    const hipsterShopPackage = this.packages.hipsterShop.hipstershop;
    const healthPackage = this.packages.health.grpc.health.v1;

    this.server.addService(
      hipsterShopPackage.PaymentService.service,
      {
        charge: HipsterShopServer.ChargeServiceHandler.bind(this)
      }
    );

    this.server.addService(
      healthPackage.Health.service,
      {
        check: HipsterShopServer.CheckHandler.bind(this)
      }
    );
  }
}

HipsterShopServer.PORT = process.env.PORT;

module.exports = HipsterShopServer;

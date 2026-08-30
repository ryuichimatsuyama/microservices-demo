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

const redisClient = createClient({
  url: process.env.REDIS_ADDR || 'redis://redis-payment:6379',
});

redisClient.on('error', (err) => {
  logger.error(`Redis error: ${err}`);
});

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
    try {
      logger.info(
        `PaymentService#Charge invoked with request ${JSON.stringify(call.request)}`
      );

      const idempotencyKey = call.request.idempotency_key;

      if (!idempotencyKey) {
        const err = new Error('idempotency_key is required');
        err.code = grpc.status.INVALID_ARGUMENT;
        throw err;
      }

      const redisKey = `payment:idempotency:${idempotencyKey}`;

      // すでに処理済みなら保存済みの結果を返す
      const cached = await redisClient.get(redisKey);

      if (cached) {
        logger.info(
          `Duplicate payment detected in Redis. Returning cached response: ${idempotencyKey}`
        );

        callback(null, JSON.parse(cached));
        return;
      }

      // 初回のみ決済処理
      const response = charge(call.request);

      await redisClient.set(
        redisKey,
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

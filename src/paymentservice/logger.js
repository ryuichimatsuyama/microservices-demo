/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const pino = require('pino');
const { trace } = require('@opentelemetry/api');

const baseLogger = pino({
  name: 'paymentservice-server',
  messageKey: 'message',
  formatters: {
    level (logLevelString, logLevelNum) {
      return { severity: logLevelString }
    }
  }
});

function withTraceContext() {
  const span = trace.getActiveSpan();

  if (!span) {
    return baseLogger;
  }

  const spanContext = span.spanContext();

  if (!spanContext || !spanContext.traceId) {
    return baseLogger;
  }

  return baseLogger.child({
    trace_id: spanContext.traceId,
    span_id: spanContext.spanId
  });
}

module.exports = {
  info: (...args) => withTraceContext().info(...args),
  warn: (...args) => withTraceContext().warn(...args),
  error: (...args) => withTraceContext().error(...args),
  debug: (...args) => withTraceContext().debug(...args)
};

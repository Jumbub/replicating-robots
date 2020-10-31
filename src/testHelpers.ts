import { apiFactory } from './application/Api';
import { loggerFactory } from './application/Logger';
import { Logger } from './theory/satisfyFacts';

let currentLabel = 'no current test';

export const setupGlobals = () => {
  describe =
    describe ||
    ((label: string, test: () => void) => {
      currentLabel = label;
      test();
    });

  it =
    it ||
    ((label: string, test: () => void) => {
      currentLabel = label;
      test();
    });
};

export const stringMatch = (expected: string, actual: string) => {
  if (expect) {
    expect(expected).toEqual(actual);
  } else {
    assert(
      expected === actual,
      `Test failure!\nExpected:\n${expected}\nActual:\n${actual}\nTest: ${currentLabel}`,
    );
  }
};

export const stringArrayMatch = (expected: string[], actual: string[]) => {
  if (expect) {
    expect(expected).toEqual(actual);
  } else {
    expected.forEach((_, i) =>
      assert(
        expected[i] === actual[i],
        `Test failure!\nExpected:\n${expected[i]}\nActual:\n${actual[i]}\nTest: ${currentLabel}`,
      ),
    );
  }
};

const isTestLogger = (logger: Logger & { logs?: string }): logger is Logger & { logs: string } =>
  logger.logs !== undefined;

export const testLoggerFactory = () => {
  const logger: Logger & { logs?: string } = loggerFactory();
  logger.logs = '';
  logger.write = (input: string, _: string) => (logger.logs += input);
  if (isTestLogger(logger)) {
    return logger;
  } else {
    throw 'testLoggerFactory failed';
  }
};

export const testApiFactory = () => {
  const api = apiFactory();
  return api;
};

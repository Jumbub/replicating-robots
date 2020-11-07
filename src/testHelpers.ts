import { Api, apiFactory } from './application/Api';
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

export const stringMatch = (actual: string, expected: string) => {
  if (expect) {
    expect(actual).toEqual(expected);
  } else {
    assert(
      expected === actual,
      `Test failure!\nExpected:\n${expected}\nActual:\n${actual}\nTest: ${currentLabel}`,
    );
  }
};

export const stringArrayMatch = (actual: string[], expected: string[]) => {
  if (expect) {
    expect(actual).toEqual(expected);
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

export type ApiMock = [keyof Api, Api[keyof Api]];
export const testApiFactory = (mocks: ApiMock[]): Api => {
  let mockCounter = 0;
  let api = {};
  Object.entries(apiFactory()).forEach(([key, value]) => {
    /** @ts-ignore */
    api[key] = (...args: unknown[]) => {
      if (mocks[mockCounter] === undefined) {
        throw `[${mockCounter}] Too many calls: ${key}`;
      } else if (mocks[mockCounter][0] !== key) {
        throw `[${mockCounter}] Bad call: ${key} (expected: ${mocks[mockCounter][0]})`;
      }
      /** @ts-ignore */
      return mocks[mockCounter++][1](...args);
    };
  });
  /** @ts-ignore */
  return api;
};

import { actionToMethodFactory } from '../logic/actionToMethod';
import { ACTION_TO_FACTS, FACT_TO_ACTION } from '../logic/factsAndActions';
import { factToMethodFactory } from '../logic/factToMethod';
import { initialStateFactory } from '../logic/state/State';
import { satisfyFacts } from '../theory/satisfyFacts';
import { setupGlobals, stringMatch, testLoggerFactory, testApiFactory } from '../testHelpers';

export const chopTreeTest = () => {
  setupGlobals();

  it('should handle empty fact list', () => {
    const api = testApiFactory();
    const logger = testLoggerFactory();

    satisfyFacts(
      [],
      FACT_TO_ACTION,
      ACTION_TO_FACTS,
      factToMethodFactory(api),
      actionToMethodFactory(api),
      initialStateFactory(),
      logger,
    );

    stringMatch(
      `$ EMPTY
| ? EMPTY
$ EMPTY
`,
      logger.logs,
    );
  });
};

if (process && process.env && process.env.NODE_ENV === 'test') {
  chopTreeTest();
}

import { actionToMethodFactory } from '../logic/actionToMethod';
import { ACTION_TO_FACTS, Fact, FACT_TO_ACTION } from '../logic/factsAndActions';
import { factToMethodFactory } from '../logic/factToMethod';
import { initialStateFactory } from '../logic/state/State';
import { satisfyFacts } from '../theory/satisfyFacts';
import {
  setupGlobals,
  stringMatch,
  testLoggerFactory,
  testApiFactory,
  ApiMock,
} from '../testHelpers';
import { getFuelLevel, move, inspect, turn, dig } from '../applicationHelpers';

export const chopTreeTest = () => {
  setupGlobals();

  it('should handle when there is no tree to chop', () => {
    const api = testApiFactory([inspect('', 'nothing')]);
    const logger = testLoggerFactory();

    satisfyFacts(
      [Fact.REMOVED_FACING_TREE],
      FACT_TO_ACTION,
      ACTION_TO_FACTS,
      factToMethodFactory(api),
      actionToMethodFactory(api),
      initialStateFactory(),
      logger,
    );

    stringMatch(
      `$ REMOVED_FACING_TREE
| ? REMOVED_FACING_TREE
$ REMOVED_FACING_TREE
`,
      logger.logs,
    );
  });

  it('should handle when there is no fuel', () => {
    const mocks: ApiMock[] = [inspect('', 'log'), getFuelLevel(0)];
    const api = testApiFactory(mocks);
    const logger = testLoggerFactory();

    satisfyFacts(
      [Fact.REMOVED_FACING_TREE],
      FACT_TO_ACTION,
      ACTION_TO_FACTS,
      factToMethodFactory(api),
      actionToMethodFactory(api),
      initialStateFactory(),
      logger,
    );

    stringMatch(
      `$ REMOVED_FACING_TREE
| ? REMOVED_FACING_TREE
| ! REMOVED_FACING_TREE
| @ MOVE_BACK_FROM_REMOVE_TREE
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, HAS_FUEL, BEYOND_AIR
| | ! UNDER_TREE
| | @ MOVE_UNDER_TREE
| | | ? HAS_FUEL, FACING_AIR
| | | ! HAS_FUEL
| | | @ DIE
| | | | ? EMPTY
| | | | DIE
X Action failed!
`,
      logger.logs,
    );
  });

  it('should handle success path', () => {
    const mocks: ApiMock[] = [
      inspect('', 'log'),
      getFuelLevel(9999),
      inspect('', 'log'),
      dig(''),
      getFuelLevel(9999),
      inspect('', 'nothing'),
      move('forward'),
      inspect('Up', 'nothing'),
      inspect('Down', 'dirt'),
      getFuelLevel(9999),
      turn('Left'),
      turn('Left'),
      inspect('', 'nothing'),
      turn('Left'),
      turn('Left'),
      move('back'),
      inspect('', 'nothing'),
    ];
    const api = testApiFactory(mocks);
    const logger = testLoggerFactory();

    satisfyFacts(
      [Fact.REMOVED_FACING_TREE],
      FACT_TO_ACTION,
      ACTION_TO_FACTS,
      factToMethodFactory(api),
      actionToMethodFactory(api),
      initialStateFactory(),
      logger,
    );

    stringMatch(
      `$ REMOVED_FACING_TREE
| ? REMOVED_FACING_TREE
| ! REMOVED_FACING_TREE
| @ MOVE_BACK_FROM_REMOVE_TREE
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, HAS_FUEL, BEYOND_AIR
| | ! UNDER_TREE
| | @ MOVE_UNDER_TREE
| | | ? HAS_FUEL, FACING_AIR
| | | ! FACING_AIR
| | | @ DIG_FORWARD
| | | | ? EMPTY
| | | | DIG_FORWARD!
| | | ? HAS_FUEL, FACING_AIR
| | | MOVE_UNDER_TREE!
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, HAS_FUEL, BEYOND_AIR
| | MOVE_BACK_FROM_REMOVE_TREE!
| ? REMOVED_FACING_TREE
$ REMOVED_FACING_TREE
`,
      logger.logs,
    );
  });
};

if (process && process.env && process.env.NODE_ENV === 'test') {
  chopTreeTest();
}

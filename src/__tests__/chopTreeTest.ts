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
import { getFuelLevel, move, inspect, turn, dig, getItemDetail } from '../applicationHelpers';

export const chopTreeTest = () => {
  setupGlobals();

  it('should handle when there is no tree to chop', () => {
    const api = testApiFactory([inspect('', 'nothing')]);
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
      logger.logs,
      `$ REMOVED_FACING_TREE
$ REMOVED_FACING_TREE
`,
    );
  });

  it('should handle when there is no fuel', () => {
    const mocks: ApiMock[] = [
      inspect('', 'log'),
      inspect('', 'log'),
      dig(''),
      inspect('', 'nothing'),
      getFuelLevel(0),
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
      logger.logs,
      `$ REMOVED_FACING_TREE
| ? REMOVED_FACING_TREE
| ! REMOVED_FACING_TREE
| @ MOVE_BACK_FROM_REMOVE_TREE
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, BEYOND_AIR, HAS_FUEL
| | ! UNDER_TREE
| | @ MOVE_UNDER_TREE
| | | ? FACING_AIR, HAS_FUEL
| | | ! FACING_AIR
| | | @ DIG_FORWARD
| | | | DIG_FORWARD!
| | | ? FACING_AIR, HAS_FUEL
| | | ! HAS_FUEL
| | | @ DIE
| | | | DIE
X Action failed!
`,
    );
  });

  it('should handle success path', () => {
    const mocks: ApiMock[] = [
      getItemDetail(1, 0),
      getItemDetail(2, 0),
      getItemDetail(3, 0),
      getItemDetail(4, 0),
      getItemDetail(5, 0),
      getItemDetail(6, 0),
      getItemDetail(7, 0),
      getItemDetail(8, 0),
      getItemDetail(9, 0),
      getItemDetail(10, 0),
      getItemDetail(11, 0),
      getItemDetail(12, 0),
      getItemDetail(13, 0),
      getItemDetail(14, 0),
      getItemDetail(15, 0),
      getItemDetail(16, 0),
      inspect('', 'log'),
      inspect('', 'log'),
      inspect('', 'log'),
      dig(''),
      inspect('', 'nothing'),
      getFuelLevel(9999),
      move('forward'),
      inspect('Up', 'log'),
      inspect('Up', 'log'),
      dig('Up'),
      inspect('Up', 'nothing'),
      getFuelLevel(9999),
      move('up'),
      inspect('Up', 'nothing'),
      inspect('Down', 'nothing'),
      inspect('Down', 'nothing'),
      getFuelLevel(9999),
      move('down'),
      inspect('Up', 'nothing'),
      inspect('Down', 'dirt'),
      turn('Left'),
      turn('Left'),
      inspect('', 'nothing'),
      turn('Left'),
      turn('Left'),
      getFuelLevel(9999),
      move('back'),
      inspect('', 'nothing'),
    ];
    const api = testApiFactory(mocks);
    const logger = testLoggerFactory();

    satisfyFacts(
      [Fact.HAS_LOG],
      FACT_TO_ACTION,
      ACTION_TO_FACTS,
      factToMethodFactory(api),
      actionToMethodFactory(api),
      initialStateFactory(),
      logger,
    );

    stringMatch(
      logger.logs,
      `$ REMOVED_FACING_TREE
| ? REMOVED_FACING_TREE
| ! REMOVED_FACING_TREE
| @ MOVE_BACK_FROM_REMOVE_TREE
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, BEYOND_AIR, HAS_FUEL
| | ! UNDER_TREE
| | @ MOVE_UNDER_TREE
| | | ? FACING_AIR, HAS_FUEL
| | | ! FACING_AIR
| | | @ DIG_FORWARD
| | | | DIG_FORWARD!
| | | ? FACING_AIR, HAS_FUEL
| | | MOVE_UNDER_TREE!
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, BEYOND_AIR, HAS_FUEL
| | ! NO_LOG_ABOVE
| | @ MOVE_UP
| | | ? BELOW_AIR, HAS_FUEL
| | | ! BELOW_AIR
| | | @ DIG_UP
| | | | DIG_UP!
| | | ? BELOW_AIR, HAS_FUEL
| | | MOVE_UP!
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, BEYOND_AIR, HAS_FUEL
| | ! ABOVE_BLOCK
| | @ MOVE_DOWN
| | | ? ABOVE_AIR, HAS_FUEL
| | | MOVE_DOWN!
| | ? UNDER_TREE, NO_LOG_ABOVE, ABOVE_BLOCK, BEYOND_AIR, HAS_FUEL
| | MOVE_BACK_FROM_REMOVE_TREE!
| ? REMOVED_FACING_TREE
$ REMOVED_FACING_TREE
`,
    );
  });
};

if (process && process.env && process.env.NODE_ENV === 'test') {
  chopTreeTest();
}

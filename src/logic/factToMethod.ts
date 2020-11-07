import { FactChecker } from '../theory/satisfyFacts';
import { State } from './state/State';
import { Fact } from './factsAndActions';
import { Api } from '../application/Api';
import { BlockId } from '../application/constants';

export const factToMethodFactory = (api: Api): FactChecker<Fact, State> => {
  const aboveBlock = (_: State) => {
    const [is] = api.inspectDown();
    return is;
  };
  const belowBlock = (_: State) => {
    const [is] = api.inspectUp();
    return is;
  };
  return {
    [Fact.NOT_AT_BASE]: (state: State) => state.gps.x + state.gps.z != 0,
    [Fact.HAS_FUEL]: (_: State) => api.getFuelLevel() > 0,
    [Fact.FACING_AIR]: (_: State) => {
      const [is] = api.inspect();
      return !is;
    },
    [Fact.REMOVED_FACING_TREE]: (_: State) => {
      const [, x] = api.inspect();
      return x === 'No block to inspect' || !x.tags['minecraft:logs'];
    },
    [Fact.NO_LOG_ABOVE]: (_: State) => {
      const [, x] = api.inspectUp();
      return x === 'No block to inspect' || !x.tags['minecraft:logs'];
    },
    [Fact.BELOW_AIR]: not(belowBlock),
    [Fact.ABOVE_AIR]: not(aboveBlock),
    [Fact.ABOVE_BLOCK]: aboveBlock,
    [Fact.BEYOND_AIR]: (_: State) => {
      if (api.turnLeft() && api.turnLeft()) {
        const [is] = api.inspect();
        if (api.turnLeft() && api.turnLeft()) {
          return !is;
        }
      }
      throw new Error('Failure to rotate??');
    },
    [Fact.HAS_LOG]: (_: State) => {
      for (let i = 1; i++; i < 16) {
        const item = api.getItemDetail(i + 1);
        if (item?.name === BlockId.OAK_LOG) {
          return true;
        }
      }
      return false;
    },
    [Fact.FACING_TREE]: (_: State) => {
      const [, x] = api.inspect();
      return x !== 'No block to inspect' && !!x.tags['minecraft:logs'];
    },
    [Fact.MOVED_FORWARD]: hasMoved,
  };
};

const not = (checker: (state: State) => boolean) => (state: State) => !checker(state);

const hasMoved = (state: State) => {
  if (state.moved === true) {
    state.moved = undefined;
    return true;
  }
  return false;
};

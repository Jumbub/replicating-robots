import { FactChecker } from '../theory/satisfyFacts';
import { State } from './state/State';
import { Fact } from './factsAndActions';
import { Api } from '../application/Api';

export const factToMethodFactory = (api: Api): FactChecker<Fact, State> => {
  const not = (checker: (state: State) => boolean) => (state: State) => !checker(state);
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
    [Fact.UNDER_TREE]: (state: State) => {
      return state.underTree;
    },
    [Fact.BELOW_AIR]: not(belowBlock),
    [Fact.GROUNDED]: aboveBlock,
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
  };
};

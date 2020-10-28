import { FactChecker } from '../theory/satisfyFacts';
import { State } from './state/State';
import { Fact } from './factsAndActions';
import { Api } from '../application/Api';

export const factToMethodFactory = (api: Api): FactChecker<Fact, State> => ({
  [Fact.NOT_AT_BASE]: (state: State) => state.gps.x + state.gps.z != 0,
  [Fact.HAS_FUEL]: (state: State) => api.getFuelLevel(state) > 0,
  [Fact.FACING_AIR]: (state: State) => {
    const [is] = api.inspect(state);
    return !is;
  },
});

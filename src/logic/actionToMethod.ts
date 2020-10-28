import { ActionToMethod } from '../theory/satisfyFacts';
import { Action } from './factsAndActions';
import { State } from './state/State';
import { Api } from '../application/Api';

export const actionToMethodFactory = (api: Api): ActionToMethod<Action, State> => ({
  [Action.MOVE_FORWARD]: (state: State) => api.forward(state),
  [Action.DIG]: (state: State) => api.dig(state),
  [Action.DIE]: () => {
    throw 'Died!';
  },
});

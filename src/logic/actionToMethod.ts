import { ActionToMethod } from '../theory/satisfyFacts';
import { Action } from './factsAndActions';
import { State } from './state/State';
import { Api } from '../application/Api';
import { ROTATION_TO_AXIS, Axis } from './state/GPS';

export const actionToMethodFactory = (api: Api): ActionToMethod<Action, State> => {
  const moveBack = (state: State) => {
    if (api.back()) {
      const [axis, sign] = ROTATION_TO_AXIS[state.gps.r];
      state.gps[axis] += sign;
      return true;
    }
    return false;
  };
  const moveForward = (state: State) => {
    if (api.forward()) {
      const [axis, sign] = ROTATION_TO_AXIS[state.gps.r];
      state.gps[axis] += sign;
      return true;
    }
    return false;
  };
  return {
    [Action.MOVE_FORWARD]: moveForward,
    [Action.MOVE_BACK]: moveBack,
    [Action.MOVE_UP]: (state: State) => {
      if (api.up()) {
        state.gps[Axis.y] += 1;
        return true;
      }
      return false;
    },
    [Action.MOVE_DOWN]: (state: State) => {
      if (api.down()) {
        state.gps[Axis.y] -= 1;
        return true;
      }
      return false;
    },
    [Action.DIG_FORWARD]: (_: State) => api.dig(),
    [Action.DIG_BACK]: (_: State) => {
      return api.turnLeft() && api.turnLeft() && api.dig() && api.turnLeft() && api.turnLeft();
    },
    [Action.DIG_UP]: (_: State) => api.digUp(),
    [Action.DIG_DOWN]: (_: State) => api.digDown(),
    [Action.DIE]: (_: State) => {
      return false;
    },
    [Action.MOVE_BACK_FROM_REMOVE_TREE]: (state: State) => {
      state.underTree = false;
      return moveBack(state);
    },
    [Action.MOVE_UNDER_TREE]: (state: State) => {
      state.underTree = true;
      return moveForward(state);
    },
  };
};

import { ActionToMethod } from '../theory/satisfyFacts';
import { Action } from './factsAndActions';
import { State } from './state/State';
import { Api } from '../application/Api';
import { ROTATION_TO_AXIS, Axis } from './state/GPS';

export const actionToMethodFactory = (api: Api): ActionToMethod<Action, State> => {
  const moveBack = (state: State) => api.back() && moved('back', state);
  const moveForward = (state: State) => api.forward() && moved('forward', state);
  const moveUp = (state: State) => api.up() && moved('up', state);
  const moveDown = (state: State) => api.down() && moved('down', state);
  return {
    [Action.MOVE_FORWARD]: moveForward,
    [Action.MOVE_BACK]: moveBack,
    [Action.MOVE_UP]: moveUp,
    [Action.MOVE_DOWN]: moveDown,
    [Action.DIG_FORWARD]: (_: State) => api.dig(),
    [Action.DIG_BACK]: (_: State) =>
      api.turnLeft() && api.turnLeft() && api.dig() && api.turnLeft() && api.turnLeft(),
    [Action.DIG_UP]: (_: State) => api.digUp(),
    [Action.DIG_DOWN]: (_: State) => api.digDown(),
    [Action.DIE]: (_: State) => true,
    [Action.MOVE_BACK_FROM_REMOVE_TREE]: moveBack,
    [Action.GET_LOG]: (_: State) => true,
  };
};

const moved = (direction: 'up' | 'back' | 'forward' | 'down', state: State) => {
  if (state.moved === false) {
    state.moved = true;
  }
  let horDirection = 0;
  let verDirection = 0;
  if (direction === 'forward') {
    horDirection = 1;
  } else if (direction === 'back') {
    horDirection = -1;
  } else if (direction === 'up') {
    verDirection = 1;
  } else if (direction === 'down') {
    verDirection = -1;
  }
  const [axis, horSign] = ROTATION_TO_AXIS[state.gps.r];
  state.gps[axis] += horSign * horDirection;
  state.gps[Axis.y] += verDirection;
  return true;
};

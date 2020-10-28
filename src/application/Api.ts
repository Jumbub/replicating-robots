import { ROTATION_TO_AXIS } from '../logic/state/GPS';
import { State } from '../logic/state/State';

export const API = {
  forward: (state: State) => {
    const [axis, sign] = ROTATION_TO_AXIS[state.gps.r];
    state.gps[axis] += sign;
    return turtle.forward();
  },
  dig: (_: State) => {
    return turtle.dig();
  },
  digUp: (_: State) => {
    return turtle.digUp();
  },
  inspect: (_: State) => {
    return turtle.inspect();
  },
  inspectUp: (_: State) => {
    return turtle.inspectUp();
  },
  getFuelLevel: (_: State) => {
    return turtle.getFuelLevel();
  },
};

export type Api = typeof API;

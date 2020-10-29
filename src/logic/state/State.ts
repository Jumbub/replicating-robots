import { Vector, ZERO_VECTOR } from './GPS';

export const INITIAL_STATE: State = {
  gps: ZERO_VECTOR,
  underTree: false,
};

export interface State {
  gps: Vector;
  underTree: boolean;
}

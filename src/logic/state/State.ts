import { Vector, ZERO_VECTOR } from './GPS';

export const INITIAL_STATE: State = {
  gps: ZERO_VECTOR,
};

export interface State {
  gps: Vector;
}

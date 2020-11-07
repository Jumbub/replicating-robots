import { Vector, ZERO_VECTOR } from './GPS';

export const initialStateFactory = (): State => ({
  gps: ZERO_VECTOR,
  moved: undefined,
});

export interface State {
  gps: Vector;
  moved?: boolean;
}

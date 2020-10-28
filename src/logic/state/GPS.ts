export const ZERO_VECTOR: Vector = {
  x: 0,
  y: 0,
  z: 0,
  r: Rotation.NORTH,
};

export const ROTATION_TO_AXIS: Record<Rotation, [Axis, 1 | -1]> = {
  [Rotation.NORTH]: [Axis.z, -1],
  [Rotation.SOUTH]: [Axis.z, 1],
  [Rotation.EAST]: [Axis.x, 1],
  [Rotation.WEST]: [Axis.x, -1],
};

export interface Vector {
  [Axis.x]: number;
  [Axis.y]: number;
  [Axis.z]: number;
  r: Rotation;
}

const enum Rotation {
  NORTH = 0,
  EAST = 1,
  SOUTH = 2,
  WEST = 3,
}

const enum Axis {
  x = 'x',
  y = 'y',
  z = 'z',
}

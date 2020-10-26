import {
  ActionToFacts,
  ActionToMethod,
  FactChecker,
  FactToAction,
  satisfyFacts,
} from '../backwardChaining/satisfyFacts';

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

export type State = {
  gps: {
    [Axis.x]: number;
    [Axis.y]: number;
    [Axis.z]: number;
    r: Rotation;
  };
};

const enum Fact {
  MOVED_FORWARD,
}

const enum Action {
  MOVE_FORWARD,
}

const rotationToAxis: Record<Rotation, [Axis, 1 | -1]> = {
  [Rotation.NORTH]: [Axis.z, -1],
  [Rotation.SOUTH]: [Axis.z, 1],
  [Rotation.EAST]: [Axis.x, 1],
  [Rotation.WEST]: [Axis.x, -1],
};

export const TurtleApi = {
  forward: (state: State) => {
    const [axis, sign] = rotationToAxis[state.gps.r];
    state.gps[axis] += sign;
    return turtle.forward();
  },
  dig: () => {
    return turtle.dig();
  },
  inspect: () => {
    return turtle.inspect();
  },
};

const actionToMethod: ActionToMethod<Action, State> = {
  [Action.MOVE_FORWARD]: (state: State) => TurtleApi.forward(state),
};
const factToAction: FactToAction<Fact, Action> = {
  [Fact.MOVED_FORWARD]: Action.MOVE_FORWARD,
};
const factChecker: FactChecker<Fact, State> = {
  [Fact.MOVED_FORWARD]: (state: State) => state.gps.x + state.gps.z > 0,
};
const actionToFacts: ActionToFacts<Fact, Action> = {
  [Action.MOVE_FORWARD]: [],
};

export const replicate = () => {
  const baseState = {
    gps: {
      x: 0,
      y: 0,
      z: 0,
      r: 0,
    },
  };

  satisfyFacts([], factChecker, factToAction, actionToFacts, actionToMethod, baseState);
};

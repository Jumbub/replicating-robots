import {
  ActionToFacts,
  ActionToMethod,
  FactChecker,
  FactToAction,
  satisfyFacts,
} from './satisfyFacts';

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
  NOT_AT_BASE,
  CAN_MOVE,
}

const enum Action {
  MOVE_FORWARD,
  DIE,
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
    console.log('MOVING FORWARD');
    return turtle.forward();
  },
  dig: () => {
    console.log('DIGGING');
    return turtle.dig();
  },
  inspect: () => {
    console.log('INSPECTING');
    return turtle.inspect();
  },
  getFuelLevel: (state: State) => {
    console.log('GETTING FUEL LEVEL');
    return turtle.getFuelLevel();
  },
};

const actionToMethod: ActionToMethod<Action, State> = {
  [Action.MOVE_FORWARD]: (state: State) => TurtleApi.forward(state),
  [Action.DIE]: () => {
    throw 'Died!';
  },
};
const factToAction: FactToAction<Fact, Action> = {
  [Fact.NOT_AT_BASE]: Action.MOVE_FORWARD,
  [Fact.CAN_MOVE]: Action.DIE,
};
const factChecker: FactChecker<Fact, State> = {
  [Fact.NOT_AT_BASE]: (state: State) => state.gps.x + state.gps.z != 0,
  [Fact.CAN_MOVE]: (state: State) => TurtleApi.getFuelLevel(state) > 0,
};
const actionToFacts: ActionToFacts<Fact, Action> = {
  [Action.MOVE_FORWARD]: [Fact.CAN_MOVE],
  [Action.DIE]: [],
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

  satisfyFacts(
    [Fact.NOT_AT_BASE],
    factChecker,
    factToAction,
    actionToFacts,
    actionToMethod,
    baseState,
  );
};

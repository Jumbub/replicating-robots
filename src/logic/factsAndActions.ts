import { ActionToFacts, FactToAction } from '../theory/satisfyFacts';

export const FACT_TO_ACTION: Readonly<FactToAction<Fact, Action>> = {
  [Fact.NOT_AT_BASE]: Action.MOVE_FORWARD,
  [Fact.HAS_FUEL]: Action.DIE, // NOT IMPLEMENTED
  [Fact.FACING_AIR]: Action.DIG_FORWARD,
  [Fact.BELOW_AIR]: Action.DIG_UP,
  [Fact.BEYOND_AIR]: Action.DIG_BACK,
  [Fact.GROUNDED]: Action.MOVE_DOWN,
  [Fact.ABOVE_AIR]: Action.DIG_DOWN,
  [Fact.ABOVE_BLOCK]: Action.MOVE_DOWN,
  [Fact.NO_LOG_ABOVE]: Action.MOVE_UP,
  [Fact.REMOVED_FACING_TREE]: Action.MOVE_BACK_FROM_REMOVE_TREE,
  [Fact.UNDER_TREE]: Action.MOVE_UNDER_TREE,
};

const TO_MOVE = [Fact.HAS_FUEL];
const TO_MOVE_FORWARD = [...TO_MOVE, Fact.FACING_AIR];
const TO_MOVE_BACKWARD = [...TO_MOVE, Fact.BEYOND_AIR];
const TO_MOVE_UP = [...TO_MOVE, Fact.BELOW_AIR];
const TO_MOVE_DOWN = [...TO_MOVE, Fact.ABOVE_AIR];
export const ACTION_TO_FACTS: Readonly<ActionToFacts<Fact, Action>> = {
  [Action.MOVE_FORWARD]: TO_MOVE_FORWARD,
  [Action.MOVE_BACK]: TO_MOVE_BACKWARD,
  [Action.MOVE_UP]: TO_MOVE_UP,
  [Action.MOVE_DOWN]: TO_MOVE_DOWN,
  [Action.DIG_FORWARD]: [],
  [Action.DIG_UP]: [],
  [Action.DIG_DOWN]: [],
  [Action.DIG_BACK]: [],
  [Action.DIE]: [],
  [Action.MOVE_BACK_FROM_REMOVE_TREE]: [
    Fact.UNDER_TREE,
    Fact.NO_LOG_ABOVE,
    Fact.ABOVE_BLOCK,
    ...TO_MOVE_BACKWARD,
  ],
  [Action.MOVE_UNDER_TREE]: [...TO_MOVE_FORWARD],
};

export const enum Fact {
  NOT_AT_BASE = 'NOT_AT_BASE',
  HAS_FUEL = 'HAS_FUEL',
  NO_LOG_ABOVE = 'NO_LOG_ABOVE',
  FACING_AIR = 'FACING_AIR',
  BELOW_AIR = 'BELOW_AIR',
  ABOVE_BLOCK = 'ABOVE_BLOCK',
  ABOVE_AIR = 'ABOVE_AIR',
  BEYOND_AIR = 'BEYOND_AIR',
  GROUNDED = 'GROUNDED',
  UNDER_TREE = 'UNDER_TREE',
  REMOVED_FACING_TREE = 'REMOVED_FACING_TREE',
}

export const enum Action {
  MOVE_UP = 'MOVE_UP',
  MOVE_DOWN = 'MOVE_DOWN',
  MOVE_FORWARD = 'MOVE_FORWARD',
  MOVE_BACK = 'MOVE_BACK',
  MOVE_BACK_FROM_REMOVE_TREE = 'MOVE_BACK_FROM_REMOVE_TREE',
  MOVE_UNDER_TREE = 'MOVE_UNDER_TREE',
  DIG_FORWARD = 'DIG_FORWARD',
  DIG_UP = 'DIG_UP',
  DIG_DOWN = 'DIG_DOWN',
  DIG_BACK = 'DIG_BACK',
  DIE = 'DIE',
}

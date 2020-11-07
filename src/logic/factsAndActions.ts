import { ActionToFacts, FactToAction } from '../theory/satisfyFacts';

export const FACT_TO_ACTION: Readonly<FactToAction<Fact, Action>> = {
  [Fact.NOT_AT_BASE]: Action.MOVE_FORWARD,

  [Fact.HAS_FUEL]: Action.DIE, // NOT IMPLEMENTED

  [Fact.FACING_AIR]: Action.DIG_FORWARD,

  [Fact.BELOW_AIR]: Action.DIG_UP,

  [Fact.BEYOND_AIR]: Action.DIG_BACK,

  [Fact.ABOVE_AIR]: Action.DIG_DOWN,
  [Fact.ABOVE_BLOCK]: Action.MOVE_DOWN,

  [Fact.HAS_LOG]: Action.GET_LOG,

  [Fact.MOVED_FORWARD]: Action.MOVE_FORWARD,

  // Logging
  [Fact.REMOVED_FACING_TREE]: Action.REMOVE_FACING_TREE,
  [Fact.NO_LOG_ABOVE]: Action.MOVE_UP,
  [Fact.FACING_TREE]: Action.DIE, // NOT IMPLEMENTED
};

const TO_MOVE = [Fact.HAS_FUEL];
const TO_MOVE_FORWARD = [Fact.FACING_AIR, ...TO_MOVE];
const TO_MOVE_BACK = [Fact.BEYOND_AIR, ...TO_MOVE];
const TO_MOVE_UP = [Fact.BELOW_AIR, ...TO_MOVE];
const TO_MOVE_DOWN = [Fact.ABOVE_AIR, ...TO_MOVE];
export const ACTION_TO_FACTS: Readonly<ActionToFacts<Fact, Action>> = {
  [Action.MOVE_FORWARD]: [TO_MOVE_FORWARD],
  [Action.MOVE_BACK]: [TO_MOVE_BACK],
  [Action.MOVE_UP]: [TO_MOVE_UP],
  [Action.MOVE_DOWN]: [TO_MOVE_DOWN],
  [Action.DIG_FORWARD]: [],
  [Action.DIG_UP]: [],
  [Action.DIG_DOWN]: [],
  [Action.DIG_BACK]: [],
  [Action.DIE]: [],
  [Action.REMOVE_FACING_TREE]: [
    [Fact.MOVED_FORWARD],
    [Fact.NO_LOG_ABOVE],
    [Fact.ABOVE_BLOCK],
    [...TO_MOVE_BACK],
  ],
  [Action.GET_LOG]: [[Fact.FACING_TREE], [Fact.REMOVED_FACING_TREE]],
};

export const enum Fact {
  // Logging
  FACING_TREE = 'FACING_TREE',
  HAS_LOG = 'HAS_LOG',
  REMOVED_FACING_TREE = 'REMOVED_FACING_TREE',
  MOVED_FORWARD = 'MOVED_FORWARD',
  NO_LOG_ABOVE = 'NO_LOG_ABOVE',

  NOT_AT_BASE = 'NOT_AT_BASE',

  HAS_FUEL = 'HAS_FUEL',

  FACING_AIR = 'FACING_AIR',

  BELOW_AIR = 'BELOW_AIR',

  ABOVE_AIR = 'ABOVE_AIR',
  ABOVE_BLOCK = 'ABOVE_BLOCK',

  BEYOND_AIR = 'BEYOND_AIR',
}

export const enum Action {
  // Logging
  REMOVE_FACING_TREE = 'REMOVE_FACING_TREE',
  GET_LOG = 'GET_LOG',

  // Api
  MOVE_UP = 'MOVE_UP',
  MOVE_DOWN = 'MOVE_DOWN',
  MOVE_FORWARD = 'MOVE_FORWARD',
  MOVE_BACK = 'MOVE_BACK',
  DIG_FORWARD = 'DIG_FORWARD',
  DIG_UP = 'DIG_UP',
  DIG_DOWN = 'DIG_DOWN',
  DIG_BACK = 'DIG_BACK',
  DIE = 'DIE',
}

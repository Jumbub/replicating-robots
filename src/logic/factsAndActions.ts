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

export const ACTION_TO_FACTS: Readonly<ActionToFacts<Fact, Action>> = {
  [Action.MOVE_FORWARD]: [Fact.HAS_FUEL, Fact.FACING_AIR],
  [Action.MOVE_UP]: [Fact.HAS_FUEL, Fact.BELOW_AIR],
  [Action.MOVE_DOWN]: [Fact.HAS_FUEL, Fact.ABOVE_AIR],
  [Action.MOVE_BACK]: [Fact.HAS_FUEL, Fact.BEYOND_AIR],
  [Action.DIG_FORWARD]: [],
  [Action.DIG_UP]: [],
  [Action.DIG_DOWN]: [],
  [Action.DIG_BACK]: [],
  [Action.DIE]: [],
  [Action.MOVE_BACK_FROM_REMOVE_TREE]: [
    Fact.HAS_FUEL,
    Fact.UNDER_TREE,
    Fact.NO_LOG_ABOVE,
    Fact.ABOVE_BLOCK,
    Fact.BEYOND_AIR,
  ],
  [Action.MOVE_UNDER_TREE]: [Fact.HAS_FUEL, Fact.FACING_AIR],
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

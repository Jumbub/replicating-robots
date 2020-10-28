import { ActionToFacts, FactToAction } from '../theory/satisfyFacts';

export const FACT_TO_ACTION: FactToAction<Fact, Action> = {
  [Fact.NOT_AT_BASE]: Action.MOVE_FORWARD,
  [Fact.HAS_FUEL]: Action.DIE,
  [Fact.FACING_AIR]: Action.DIG,
};

export const ACTION_TO_FACTS: ActionToFacts<Fact, Action> = {
  [Action.MOVE_FORWARD]: [Fact.HAS_FUEL, Fact.FACING_AIR],
  [Action.DIG]: [],
  [Action.DIE]: [],
};

export const enum Fact {
  NOT_AT_BASE = 'NOT_AT_BASE',
  HAS_FUEL = 'HAS_FUEL',
  FACING_AIR = 'FACING_AIR',
}

export const enum Action {
  MOVE_FORWARD = 'MOVE_FORWARD',
  DIG = 'DIG',
  DIE = 'DIE',
}

import { API } from './application/Api';
import { LOGGER } from './application/Logger';
import { actionToMethodFactory } from './logic/actionToMethod';
import { ACTION_TO_FACTS, Fact, FACT_TO_ACTION } from './logic/factsAndActions';
import { factToMethodFactory } from './logic/factToMethod';
import { INITIAL_STATE } from './logic/state/State';
import { satisfyFacts } from './theory/satisfyFacts';

satisfyFacts(
  [Fact.REMOVED_FACING_TREE],
  FACT_TO_ACTION,
  ACTION_TO_FACTS,
  factToMethodFactory(API),
  actionToMethodFactory(API),
  INITIAL_STATE,
  LOGGER,
);

import { apiFactory } from './application/Api';
import { loggerFactory } from './application/Logger';
import { actionToMethodFactory } from './logic/actionToMethod';
import { ACTION_TO_FACTS, Fact, FACT_TO_ACTION } from './logic/factsAndActions';
import { factToMethodFactory } from './logic/factToMethod';
import { initialStateFactory } from './logic/state/State';
import { theoryTest } from './__tests__/thoeryTest';
import { satisfyFacts } from './theory/satisfyFacts';
import { emptyFactsTest } from './__tests__/emptyFactsTest';
import { chopTreeTest } from './__tests__/chopTreeTest';

const logger = loggerFactory();

try {
  theoryTest();
  emptyFactsTest();
  chopTreeTest();
  logger.print('Tests passed!', 'lime');

  // const api = apiFactory();
  // satisfyFacts(
  //   [Fact.REMOVED_FACING_TREE],
  //   FACT_TO_ACTION,
  //   ACTION_TO_FACTS,
  //   factToMethodFactory(api),
  //   actionToMethodFactory(api),
  //   initialStateFactory(),
  //   logger,
  // );
} catch (err) {
  const fileName = 'errors.txt';
  const errFile = fs.open(fileName, 'a');

  errFile.write('\n\n' + err);
  errFile.close();

  logger.print(err, 'red');
  logger.print('See: ' + fileName, 'yellow');
}

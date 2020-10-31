/**
 * Use backward chaining to satisfy the required facts
 */
export const satisfyFacts = <TFact extends string, TAction extends string, TState>(
  facts: TFact[],
  factToAction: FactToAction<TFact, TAction>,
  actionToFacts: ActionToFacts<TFact, TAction>,
  factIsTrue: FactChecker<TFact, TState>,
  actionToMethod: ActionToMethod<TAction, TState>,
  state: TState,
  logger: Logger,
): void => {
  log(logger, 0, 'satisfyFacts', facts.join(', '));
  let tasks: Task<TFact, TAction>[] = [[null, facts]];
  let success = true;

  while (tasks.length > 0) {
    const [[action, requiredFacts]] = tasks;
    log(logger, tasks.length, 'checking', requiredFacts.join(', '));

    const unsatisfiedFact = requiredFacts.find(fact => !factIsTrue[fact](state));

    if (unsatisfiedFact !== undefined) {
      log(logger, tasks.length, 'unsatisfiedFact', unsatisfiedFact);

      const action = factToAction[unsatisfiedFact];
      const requirements = actionToFacts[action];
      log(logger, tasks.length, 'factToAction', action);

      tasks.unshift([action, requirements]);
    } else {
      if (action !== null) {
        log(logger, tasks.length, 'actionToMethod', action);
        const result = actionToMethod[action](state);
        if (!result) {
          success = false;
          tasks = [];
        } else {
          log(logger, tasks.length, 'actionToMethod!', action);
        }
      }

      tasks.shift();
    }
  }

  if (success) {
    log(logger, 0, 'return', facts.join(', '));
  } else {
    log(logger, 0, 'failure', 'X Action failed!');
  }
};

const log = (
  logger: Logger,
  depth: number,
  key:
    | 'satisfyFacts'
    | 'checking'
    | 'unsatisfiedFact'
    | 'factToAction'
    | 'actionToMethod'
    | 'actionToMethod!'
    | 'failure'
    | 'return',
  value: string,
) => {
  if (key === 'actionToMethod!') {
    logger.print('!', 'lime');
    return;
  }

  logger.write('| '.repeat(depth), 'gray');

  if (value === '') {
    value = 'EMPTY';
  }

  if (key === 'satisfyFacts') {
    logger.write('$ ');
    logger.print(value, 'yellow');
  } else if (key === 'checking') {
    logger.write('? ', 'yellow');
    logger.print(value);
  } else if (key === 'unsatisfiedFact') {
    logger.write('! ', 'red');
    logger.print(value);
  } else if (key === 'factToAction') {
    logger.write('@ ', 'gray');
    logger.print(value);
  } else if (key === 'actionToMethod') {
    logger.write(value, 'lime');
  } else if (key === 'failure') {
    logger.print('\n' + value, 'red');
  } else if (key === 'return') {
    logger.write('$ ');
    logger.print(value, 'lime');
  }
};

type Task<TFact, TAction> = [desiredAction: TAction | null, requiredFacts: TFact[]];

export type Logger = {
  print: (input: string, color?: string) => void;
  write: (input: string, color?: string) => void;
};
export type FactChecker<TFact extends string, TState> = Record<TFact, (state: TState) => boolean>;
export type FactToAction<TFact extends string, TAction extends string> = Record<TFact, TAction>;
export type ActionToFacts<TFact extends string, TAction extends string> = Record<TAction, TFact[]>;
export type ActionToMethod<TAction extends string, TState> = Record<
  TAction,
  (state: TState) => boolean
>;

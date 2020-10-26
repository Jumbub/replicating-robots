/**
 * Use backward chaining to satisfy the required facts
 */
export const satisfyFacts = <TFact extends EnumKey, TAction extends EnumKey, TState>(
  facts: TFact[],
  factIsTrue: FactChecker<TFact, TState>,
  factToAction: FactToAction<TFact, TAction>,
  actionToFacts: ActionToFacts<TFact, TAction>,
  actionToMethod: ActionToMethod<TAction, TState>,
  state: TState,
): void => {
  let tasks: Task<TFact, TAction>[] = [[null, facts]];

  while (tasks.length > 0) {
    const [[action, requiredFacts]] = tasks;

    const unsatisfiedFact = requiredFacts.find(fact => !factIsTrue[fact](state));

    if (unsatisfiedFact !== undefined) {
      const action = factToAction[unsatisfiedFact];
      const requirements = actionToFacts[action];

      tasks.unshift([action, requirements]);
    } else {
      if (action !== null) {
        actionToMethod[action](state);
      }

      tasks.shift();
    }
  }
};

type Task<TFact, TAction> = [desiredAction: TAction | null, requiredFacts: TFact[]];
type EnumKey = number | string | symbol;

export type FactChecker<TFact extends EnumKey, TState> = Record<TFact, (state: TState) => boolean>;
export type FactToAction<TFact extends EnumKey, TAction extends EnumKey> = Record<TFact, TAction>;
export type ActionToFacts<TFact extends EnumKey, TAction extends EnumKey> = Record<
  TAction,
  TFact[]
>;
export type ActionToMethod<TAction extends EnumKey, TState> = Record<
  TAction,
  (state: TState) => void
>;

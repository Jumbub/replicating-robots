describe('demo situation', () => {
  type State = {
    moves: string[];
    facingSomething: boolean;
  };

  const GAME_OVER = 'GameOver';
  type GameOver = typeof GAME_OVER;
  const enum Fact {
    FACING_SOMETHING,
    FACING_NOTHING,
    MOVED_FORWARD,
  }
  const enum Action {
    MOVE_FORWARD,
    DESTROY_WHATEVER_FACING,
    NOTHING,
    UNKNOWN,
  }

  const api = {
    destroyWhateverFacing: (state: State) => {
      state.moves.push('doing action: destroying whatever facing');
      state.facingSomething = false;
    },
    moveForward: (state: State) => {
      state.moves.push('doing action: move forward');
      state.facingSomething = true;
    },
    isFacingSomething: (state: State) => {
      state.moves.push('checking fact: is facing something');
      return state.facingSomething;
    },
  };

  const performAction: ActionPerformer = {
    [Action.MOVE_FORWARD]: (state: State) => api.moveForward(state),
    [Action.DESTROY_WHATEVER_FACING]: (state: State) => api.destroyWhateverFacing(state),
    [Action.NOTHING]: () => void null,
    [Action.UNKNOWN]: () => {
      throw 'unknown state';
    },
  };
  const satisfactionAction: SatisfactionAction = {
    [Fact.FACING_SOMETHING]: Action.UNKNOWN,
    [Fact.FACING_NOTHING]: Action.DESTROY_WHATEVER_FACING,
    [Fact.MOVED_FORWARD]: Action.MOVE_FORWARD,
  };
  const isSatisfied: IsSatisfied = {
    [Fact.FACING_SOMETHING]: (state: State) => api.isFacingSomething(state),
    [Fact.FACING_NOTHING]: (state: State) => !api.isFacingSomething(state),
    [Fact.MOVED_FORWARD]: (state: State) => {
      state.moves.push('checking fact: has moved forward');
      return state.moves.includes('doing action: move forward');
    },
  };
  const satisfactionRequirements: SatisfactionRequirements = {
    [Action.MOVE_FORWARD]: [Fact.FACING_NOTHING],
    [Action.DESTROY_WHATEVER_FACING]: [Fact.FACING_SOMETHING],
    [Action.NOTHING]: [],
    [Action.UNKNOWN]: [],
  };

  type IsSatisfied = Record<Fact, (state: State) => boolean>;
  type SatisfactionRequirements = Record<Action, Fact[]>;
  type SatisfactionAction = Record<Fact, Action>;
  type ActionPerformer = Record<Action, (state: State) => void>;
  type Task = [desiredAction: Action, requiredFacts: Fact[]];

  const satisfyFacts = (
    facts: Fact[],
    isSatisfied: IsSatisfied,
    satisfactionRequirements: SatisfactionRequirements,
    satisfactionAction: SatisfactionAction,
    performAction: ActionPerformer,
    state: State,
  ): void | GameOver => {
    let taskList: Task[] = [[Action.NOTHING, facts]];
    while (taskList.length) {
      const [[action, requiredFacts]] = taskList;

      const unsatisfiedFact = requiredFacts.find(fact => !isSatisfied[fact](state));

      if (unsatisfiedFact) {
        const action = satisfactionAction[unsatisfiedFact];
        const requirements = satisfactionRequirements[action];

        taskList.unshift([action, requirements]);
        continue;
      }

      performAction[action](state);
      taskList.shift();
    }
  };

  it('should solve (1)', () => {
    let state: State = {
      moves: [],
      facingSomething: false,
    };

    satisfyFacts(
      [Fact.FACING_NOTHING],
      isSatisfied,
      satisfactionRequirements,
      satisfactionAction,
      performAction,
      state,
    );

    expect(state.moves).toEqual([
      'checking fact: is facing something', // initial fact check
    ]);
  });

  it('should solve (2)', () => {
    let state: State = {
      moves: [],
      facingSomething: true,
    };

    satisfyFacts(
      [Fact.FACING_NOTHING],
      isSatisfied,
      satisfactionRequirements,
      satisfactionAction,
      performAction,
      state,
    );

    expect(state.moves).toEqual([
      'checking fact: is facing something', // initial fact check
      'checking fact: is facing something', // check fact to perform destruction
      'doing action: destroying whatever facing', // satisfy initial fact
      'checking fact: is facing something', // re-check initial fact
    ]);
  });

  it('should solve (3)', () => {
    let state: State = {
      moves: [],
      facingSomething: false,
    };

    satisfyFacts(
      [Fact.MOVED_FORWARD],
      isSatisfied,
      satisfactionRequirements,
      satisfactionAction,
      performAction,
      state,
    );

    expect(state.moves).toEqual([
      'checking fact: has moved forward', // initial fact check
      'checking fact: is facing something', // check if can move forward
      'doing action: move forward', // move forward
      'checking fact: has moved forward', // re-check initial fact
    ]);
  });

  it('should solve (4)', () => {
    let state: State = {
      moves: [],
      facingSomething: true,
    };

    satisfyFacts(
      [Fact.MOVED_FORWARD],
      isSatisfied,
      satisfactionRequirements,
      satisfactionAction,
      performAction,
      state,
    );

    expect(state.moves).toEqual([
      'checking fact: has moved forward', // initial fact check
      'checking fact: is facing something', // check if can move forward
      'checking fact: is facing something', // check if can destroy object
      'doing action: destroying whatever facing', // destroy blocking object
      'checking fact: is facing something', // re-check if can move forward
      'doing action: move forward', // move forward
      'checking fact: has moved forward', // re-check initial fact
    ]);
  });
});

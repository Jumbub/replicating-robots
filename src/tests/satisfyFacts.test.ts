import {
  ActionToFacts,
  ActionToMethod,
  FactChecker,
  FactToAction,
  Logger,
  satisfyFacts,
} from '../satisfyFacts';

describe('demo situation', () => {
  type State = {
    moves: string[];
    facingSomething: boolean;
  };
  const enum Fact {
    FACING_SOMETHING = 'FACING_SOMETHING',
    FACING_NOTHING = 'FACING_NOTHING',
    MOVED_FORWARD = 'MOVED_FORWARD',
  }
  const enum Action {
    MOVE_FORWARD = 'MOVE_FORWARD',
    DESTROY_WHATEVER_FACING = 'DESTROY_WHATEVER_FACING',
    NOTHING = 'NOTHING',
    UNKNOWN = 'UNKNOWN',
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
  const actionToMethod: ActionToMethod<Action, State> = {
    [Action.MOVE_FORWARD]: (state: State) => api.moveForward(state),
    [Action.DESTROY_WHATEVER_FACING]: (state: State) => api.destroyWhateverFacing(state),
    [Action.NOTHING]: () => {},
    [Action.UNKNOWN]: () => {
      throw 'unknown state';
    },
  };
  const factToAction: FactToAction<Fact, Action> = {
    [Fact.FACING_SOMETHING]: Action.UNKNOWN,
    [Fact.FACING_NOTHING]: Action.DESTROY_WHATEVER_FACING,
    [Fact.MOVED_FORWARD]: Action.MOVE_FORWARD,
  };
  const factChecker: FactChecker<Fact, State> = {
    [Fact.FACING_SOMETHING]: (state: State) => api.isFacingSomething(state),
    [Fact.FACING_NOTHING]: (state: State) => !api.isFacingSomething(state),
    [Fact.MOVED_FORWARD]: (state: State) => {
      state.moves.push('checking fact: has moved forward');
      return state.moves.includes('doing action: move forward');
    },
  };
  const actionToFacts: ActionToFacts<Fact, Action> = {
    [Action.MOVE_FORWARD]: [Fact.FACING_NOTHING],
    [Action.DESTROY_WHATEVER_FACING]: [Fact.FACING_SOMETHING],
    [Action.NOTHING]: [],
    [Action.UNKNOWN]: [],
  };

  it('should solve: remove blocker when nothing to remove', () => {
    let state: State = {
      moves: [],
      facingSomething: false,
    };

    satisfyFacts(
      [Fact.FACING_NOTHING],
      factChecker,
      factToAction,
      actionToFacts,
      actionToMethod,
      state,
      () => {},
    );

    expect(state.moves).toEqual([
      'checking fact: is facing something', // initial fact check
    ]);
  });

  it('should solve: remove blocker when something to remove', () => {
    let state: State = {
      moves: [],
      facingSomething: true,
    };

    satisfyFacts(
      [Fact.FACING_NOTHING],
      factChecker,
      factToAction,
      actionToFacts,
      actionToMethod,
      state,
      () => {},
    );

    expect(state.moves).toEqual([
      'checking fact: is facing something', // initial fact check
      'checking fact: is facing something', // check fact to perform destruction
      'doing action: destroying whatever facing', // satisfy initial fact
      'checking fact: is facing something', // re-check initial fact
    ]);
  });

  it('should solve: move forward without blocker', () => {
    let state: State = {
      moves: [],
      facingSomething: false,
    };

    satisfyFacts(
      [Fact.MOVED_FORWARD],
      factChecker,
      factToAction,
      actionToFacts,
      actionToMethod,
      state,
      () => {},
    );

    expect(state.moves).toEqual([
      'checking fact: has moved forward', // initial fact check
      'checking fact: is facing something', // check if can move forward
      'doing action: move forward', // move forward
      'checking fact: has moved forward', // re-check initial fact
    ]);
  });

  it('should solve: move forward with blocker', () => {
    let state: State = {
      moves: [],
      facingSomething: true,
    };

    satisfyFacts(
      [Fact.MOVED_FORWARD],
      factChecker,
      factToAction,
      actionToFacts,
      actionToMethod,
      state,
      () => {},
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

  it('should log correctly', () => {
    let state: State = {
      moves: [],
      facingSomething: true,
    };

    const logs: string[] = [];
    const logger: Logger = (input: string) => {
      logs.push(input);
    };

    satisfyFacts(
      [Fact.MOVED_FORWARD],
      factChecker,
      factToAction,
      actionToFacts,
      actionToMethod,
      state,
      logger,
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

    expect(logs).toEqual([
      'satisfying MOVED_FORWARD',
      '| need  MOVED_FORWARD',
      '| not   MOVED_FORWARD',
      '| will  MOVE_FORWARD',
      '| | need  FACING_NOTHING',
      '| | not   FACING_NOTHING',
      '| | will  DESTROY_WHATEVER_FACING',
      '| | | need  FACING_SOMETHING',
      '| | |       DESTROY_WHATEVER_FACING',
      '| | need  FACING_NOTHING',
      '| |       MOVE_FORWARD',
      '| need  MOVED_FORWARD',
      'satisfied MOVED_FORWARD',
    ]);
  });
});

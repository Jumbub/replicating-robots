import { Derive, executeTask, MutatorResult, StateMutator } from './statelessTask';

it('should complete the demo', () => {
  interface GlobalState {
    lastStateStatus?: string;
  }
  interface TestState {
    stateKey?: string;
  }

  interface TestApi {
    jump: (globalState: GlobalState) => { info: string };
  }

  const globalState: GlobalState = {};

  const api: TestApi = {
    jump: (globalState: GlobalState) => {
      globalState.lastStateStatus = 'did jump!';
      return { info: 'did jump!' };
    },
  };

  const execute = (api: TestApi, call: keyof TestApi) => {
    return api[call](globalState);
  };

  const hasInfoResult = (result: unknown): result is { info: string } => {
    if (typeof result === 'object' && result !== null && 'info' in result) {
      return true;
    }
    return false;
  };
  const derive: Derive<TestApi, TestState> = () => [
    'jump',
    (result, state) => {
      if (hasInfoResult(result)) {
        state.stateKey = result.info;
        return null;
      } else throw 'shoudnt happen';
    },
  ];

  const state = executeTask<TestApi, TestState>(derive, execute, api, {});

  expect(state).toEqual({
    stateKey: 'did jump!',
  });

  expect(globalState).toEqual({
    lastStateStatus: 'did jump!',
  });
});

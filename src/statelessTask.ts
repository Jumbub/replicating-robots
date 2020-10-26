// export type ApiMethod<TApi> = keyof TApi;
// export type ApiResult = unknown;

// export type MutatorResult<TApi, TState> = [Derive<TApi, TState> | null, TState];
// export type StateMutator<TApi, TState> = (
//   result: ApiResult,
//   state: TState,
// ) => Derive<TApi, TState> | null;

// export type Derive<TApi, TState> = (state: TState) => [ApiMethod<TApi>, StateMutator<TApi, TState>];
// export type Execute<TApi> = (api: TApi, call: ApiMethod<TApi>) => ApiResult;

// export const executeTask = <TApi, TState>(
//   initialDerive: Derive<TApi, TState>,
//   execute: Execute<TApi>,
//   api: TApi,
//   initialState: TState,
// ) => {
//   let mutableState = initialState;
//   let mutableDerive: Derive<TApi, TState> | null = initialDerive;

//   do {
//     const [apiCall, stateMutator] = mutableDerive(mutableState);
//     const apiResult = execute(api, apiCall);
//     mutableDerive = stateMutator(apiResult, mutableState);
//     if (mutableDerive === null) break;
//   } while (true);

//   return mutableState;
// };

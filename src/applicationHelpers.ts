import { Api, apiFactory } from './application/Api';
import { ApiMock } from './testHelpers';

export const INSPECTIONS: Record<'log' | 'nothing' | 'dirt', InspectResult> = {
  log: [true, { name: 'minecraft:oak_log', tags: { 'minecraft:logs': true } }],
  dirt: [true, { name: 'minecraft:dirt', tags: {} }],
  nothing: [false, 'No block to inspect'],
};

type ActionDirections = 'Up' | 'Down' | '';

const API_VALUE = apiFactory();
const actionWithDirection = (action: string) => {
  if (actionWithDirectionIs(action)) {
    return action;
  } else {
    throw new Error('INVALID MOCK API ACTION! ' + action);
  }
};
const actionWithDirectionIs = (action: string): action is keyof Api => {
  return action in API_VALUE;
};

export const inspect = (direction: ActionDirections, thing: keyof typeof INSPECTIONS): ApiMock => [
  actionWithDirection('inspect' + direction),
  () => INSPECTIONS[thing],
];

export const dig = (direction: ActionDirections): ApiMock => [
  actionWithDirection('dig' + direction),
  () => true,
];

export const turn = (direction: 'Left' | 'Right'): ApiMock => [
  actionWithDirection('turn' + direction),
  () => true,
];

export const move = (direction: 'up' | 'down' | 'forward' | 'back', result?: boolean): ApiMock => [
  direction,
  () => result || true,
];

export const getFuelLevel = (n: number): ApiMock => ['getFuelLevel', () => n];

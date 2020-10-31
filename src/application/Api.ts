export const apiFactory = () => ({
  up: () => {
    return turtle.up();
  },
  down: () => {
    return turtle.down();
  },
  forward: () => {
    return turtle.forward();
  },
  back: () => {
    return turtle.back();
  },
  dig: () => {
    return turtle.dig();
  },
  digUp: () => {
    return turtle.digUp();
  },
  digDown: () => {
    return turtle.digDown();
  },
  inspect: () => {
    return turtle.inspect();
  },
  inspectUp: () => {
    return turtle.inspectUp();
  },
  turnLeft: () => {
    return turtle.turnLeft();
  },
  turnRight: () => {
    return turtle.turnRight();
  },
  inspectDown: () => {
    return turtle.inspectDown();
  },
  getFuelLevel: () => {
    return turtle.getFuelLevel();
  },
});

export type Api = ReturnType<typeof apiFactory>;

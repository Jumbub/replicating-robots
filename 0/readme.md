#

## Task Stack

- tasks are managed on a stack
- while executing a task, if it throws an error containing a task, it will push that task to the stack
  (e.g. a "move" task can throw an error containing a "refuel" task)
  - if a task throws an exception, it is not popped from the stack, but it will not be under the new task in the stack

## Task

- idempotent
  - tasks are absolute, there are no relative tasks
    (e.g. no move forward 1, only move to x, y, z)
  - tasks can be completed across reboots
    (e.g. when the turtle loses all memory of completed/in-progress actions for a task)

Tasks _must_ be idempotent because they are persisted. When the robot reboots, it must be able to re-execute the task from the beginning.

## Action

- not idempotent
  - may interact with the world
  - may mutate persisted state

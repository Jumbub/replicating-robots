--- @class PlainTask A task about to be queued
--- @field name string
--- @field args? table

--- @class Task A task after it's metadata is generated and applied
--- @field name string
--- @field run function
--- @field id string

--- @class TaskContext The context for task execution
--- @field task Task
--- @field args table
--- @field state State
--- @field tasks TaskStack

--- @class State The context for task execution
--- @field gps? Vector

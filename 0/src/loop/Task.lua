--- @class Task
--- @field name string
--- @field args? table

--- @class TaskContext Context for task execution
--- @field args table
--- @field state TaskState
--- @field push function
--- @field complete function

--- @class TaskState Shared data between tasks (not persisted across reboots)
--- @field gps? Vector

--- @class Task
--- @field name string
--- @field args? table

--- @class TaskContext Context for task execution
--- @field args table
--- @field state TaskState

--- @class TaskState Shared data between tasks (not persisted across reboots)
--- @field location? Vector world coordinates or relative from start point
--- @field orientation? number 0 north, 1 east, 2 south, 3 west

local File = require("src.data.File")

--- @class FileLogger
--- @field path string
local FileLogger = {}
FileLogger.__index = FileLogger

--- @param path string
--- @return FileLogger
function FileLogger.new(path)
  return setmetatable({ path = path }, FileLogger)
end

--- @param level string
--- @param message string
function FileLogger:log(level, message)
  local debug = debug.getinfo(4, "Sl")
  local time = os.date("%FT%T")
  File.append(self.path, string.format("[%s] %s:%d [%s] %s", time, debug.short_src, debug.currentline, level, message))
end

return FileLogger

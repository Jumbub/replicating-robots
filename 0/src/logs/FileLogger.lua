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

local function getDebugInfo()
  local debug = debug.getinfo(5, "Sl")
  return string.format("%s:%d", debug.short_src, debug.currentline)
end

--- @param level string
--- @param message string
function FileLogger:log(level, message)
  local time = os.date("%FT%T")
  local trace = (level == "error" or level == "debug") and getDebugInfo() or ""
  File.append(self.path, string.format("[%s][%s]%s %s", time, level, trace, message))
end

return FileLogger

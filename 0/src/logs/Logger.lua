local TerminalLogger = require("src.logs.TerminalLogger")
local Formatter = require("src.logs.Formatter")

--- @class Logger
--- @field fileLogger FileLogger
local Logger = {}
Logger.__index = Logger

--- @param fileLogger FileLogger
--- @return Logger
function Logger.new(fileLogger)
  return setmetatable({ fileLogger = fileLogger }, Logger)
end

function Logger:info(...)
  self:log("info", ...)
end

function Logger:warning(...)
  self:log("warning", ...)
end

function Logger:error(...)
  self:log("error", ...)
end

function Logger:setupGlobalDebug()
  _G.dd = function(...)
    self:log("debug", ...)
  end
  return self
end

--- @param level string
function Logger:log(level, ...)
  local message = Formatter.unknown(...) .. "\n"

  TerminalLogger.log(level, message)
  self.fileLogger:log(level, message)
end

return Logger

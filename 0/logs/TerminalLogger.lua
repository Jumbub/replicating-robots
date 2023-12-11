--- @class TerminalLogger
local TerminalLogger = {}

local COLOR_FOR_LEVEL = {
  info = colors.yellow,
  warning = colors.orange,
  error = colors.red,
  debug = colors.lightGray,
}

--- @param level string
--- @param message string
function TerminalLogger.log(level, message)
  term.setTextColor(COLOR_FOR_LEVEL[level])
  write(message)
end

return TerminalLogger

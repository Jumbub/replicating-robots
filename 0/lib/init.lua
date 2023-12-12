Utility = require("lib.lua-utility.lib.utility")
Array = require("lib.lua-utility.lib.utility.array")
Object = require("lib.lua-utility.lib.utility.object")
String = require("lib.lua-utility.lib.utility.string")
Function = require("lib.lua-utility.lib.utility.function")

---@param n number
function math.sign(n)
  if n < 0 then
    return -1
  elseif n > 0 then
    return 1
  end
  return 0
end

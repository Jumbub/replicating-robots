local Trace = {}

local function listToDict(list)
  local dict = {}
  for _, v in pairs(list) do
    dict[v] = true
  end
  return dict
end

--- @param table table
--- @param log Logger
--- @param blacklist table
function Trace.table(table, log, blacklist)
  local blackdict = listToDict(blacklist)

  return setmetatable({}, {
    __index = function(_, key)
      local value = table[key]

      if blackdict[key] then
        return value
      end

      if type(value) == "function" then
        return function(...)
          local result = { value(...) }
          log:info(key, { ... }, result)
          return unpack(result)
        end
      end

      return value
    end,
  })
end

return Trace

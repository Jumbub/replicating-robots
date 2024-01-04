local inventory = {}

--- @param match table
--- @return nil|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
function inventory.find(match)
  for i = 1, 16 do
    local info = turtle.getItemDetail(i) or { tags = {} }

    if match.name == nil or match.name == info.name then
      local allTagsMatch = true
      for key, value in pairs(match.tags or {}) do
        allTagsMatch = allTagsMatch and info.tags[key] == value
      end
      if allTagsMatch then
        return i
      end
    end
  end
end

--- @param slot 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
--- @return boolean
function inventory.select(slot)
  return turtle.select(slot)
end

--- @param match table
--- @return boolean
function inventory.findThenSelect(match)
  local slot = inventory.find(match)
  if not slot then
    return false
  end
  return inventory.select(slot)
end

return inventory

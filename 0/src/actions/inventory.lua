local inventory = {}

function inventory.find(name)
  for i = 1, 16 do
    local info = turtle.getItemDetail(i)
    if info and info.name == name then
      return turtle.select(i)
    end
  end
  return false
end

return inventory

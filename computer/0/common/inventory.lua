require("common")

local itemName = function(i)
	local item = turtle.getItemDetail(i)
	if item then
		return item.name
	end
	return ""
end

local itemNameContains = function(i, name)
	if name == "" then
		return false
	end
	return string.find(itemName(i), name) and true or false
end

local find = function(name)
	local index = Range(16):findIndex(function(i)
		return itemNameContains(i, name)
	end)
	if index == -1 then
		return nil
	end
	return index
end

local select = function(name)
	local slot = find(name)
	if not slot then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select slot: " .. slot)
end

local equip = function(name)
	if name == "minecraft:crafting_table" and turtle.craft then
		return true
	end
	if not select(name) then
		return false
	end
	return assert(turtle.equipLeft(), "Somehow failed to equip on left side")
end

local selectEmpty = function()
	local slot = Range(16):findIndex(function(i)
		return not turtle.getItemDetail(i)
	end)
	if not slot then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select inventory slot")
end

return {
	find = find,
	select = select,
	equip = equip,
	selectEmpty = selectEmpty,
	itemName = itemName,
	itemNameContains = itemNameContains,
}

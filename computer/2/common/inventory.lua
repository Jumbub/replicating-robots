local m = {}

m.itemName = function(i)
	local item = turtle.getItemDetail(i)
	if item then
		return item.name
	end
	return ""
end

m.itemNameContains = function(i, name)
	if name == "" then
		return false
	end
	return string.find(m.itemName(i), name) and true or false
end

m.find = function(name)
	local index = c.range(16):findIndex(function(i)
		return c.inventory.itemNameContains(i, name)
	end)
	if index == -1 then
		return nil
	end
	return index
end

m.select = function(name)
	local slot = c.inventory.find(name)
	if not slot then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select slot: " .. slot)
end

m.equip = function(name)
	if name == "minecraft:crafting_table" and turtle.craft then
		return true
	end
	if not c.inventory.select(name) then
		return false
	end
	local action = turtle.equipLeft
	if name == "minecraft:diamond_pickaxe" then
		action = turtle.equipRight
	end
	return assert(action(), "Somehow failed to equip on left side")
end

m.selectEmpty = function()
	local slot = c.range(16):findIndex(function(i)
		return not turtle.getItemDetail(i)
	end)
	if slot == -1 then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select inventory slot")
end

m.selectNonEmpty = function()
	local slot = c.range(16):findIndex(function(i)
		return turtle.getItemDetail(i)
	end)
	if slot == -1 then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select inventory slot")
end

m.slotsUsed = function()
	return c.range(16):filter(function()
		return turtle.getItemDetail()
	end)
end

return m

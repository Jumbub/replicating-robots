local m = {}

local matchSingleOrMany = function(needle, haystack)
	if type(haystack) == "string" then
		return needle == haystack
	else
		return Array(haystack):includes(needle)
	end
end

-- Takes a name string, or array of name strings
m.count = function(name)
	return c.range(16)
		:map(function(i)
			local detail = turtle.getItemDetail(i)
			if not detail then
				return { "", i }
			end
			return { detail.name, i }
		end)
		:filter(function(v)
			return matchSingleOrMany(v[1], name)
		end)
		:reduce(function(acc, v)
			return acc + turtle.getItemCount(v[2])
		end, 0)
end

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

m.findExact = function(name)
	local index = c.range(16):find(function(i)
		return turtle.getItemDetail(i).name == name
	end)
	if index == -1 then
		return nil
	end
	return index
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
	return assert(action(), "Somehow failed to equip " .. name)
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
	return #c.range(16):filter(function(i)
		return turtle.getItemDetail(i)
	end)
end

m.organise = function()
	local freeSlots = {}
	c.range(16):forEach(function(slot)
		local detail = turtle.getItemDetail(slot)
		if not detail then
			return
		end
		local name = detail.name
		local freeSlot = freeSlots[name]
		if freeSlot then
			turtle.select(slot)
			turtle.transferTo(freeSlot)

			if turtle.getItemCount(slot) > 0 then
				freeSlots[name] = slot
			elseif turtle.getItemSpace(freeSlot) == 0 then
				freeSlots[name] = nil
			end
		elseif turtle.getItemSpace(slot) > 0 then
			freeSlots[name] = slot
		end
	end)
end

return m

local m = {}

local matchNameOnNames = function(needle, haystack)
	if type(haystack) == "string" then
		return needle == haystack
	else
		return Array(haystack):includes(needle)
	end
end

local matchDetailOnNames = function(detail, haystack)
	detail = detail or { name = "cidjwuaycpduql" }
	return matchNameOnNames(detail.name, haystack)
end

m.largestCount = function(names)
	return unpack(
		Array(names):map(function(name)
			return { name, m.count(name) }
		end):sort(function(a, b)
			return a[2] >= b[2]
		end)[1] or {}
	)
end

m.count = function(name)
	return c.range(16)
		:map(function(i)
			return { m.itemName(i), i }
		end)
		:filter(function(v)
			return matchNameOnNames(v[1], name)
		end)
		:reduce(function(acc, v)
			return acc + turtle.getItemCount(v[2])
		end, 0)
end

m.itemName = function(slot)
	local item = turtle.getItemDetail(slot)
	if item then
		return item.name
	end
	return ""
end

-- Takes a name string, or array of name strings
m.slotContains = function(slot, name)
	return matchDetailOnNames(turtle.getItemDetail(slot), name)
end

m.find = function(name)
	local index = c.range(16):findIndex(function(slot)
		return matchDetailOnNames(turtle.getItemDetail(slot), name)
	end)
	if index == -1 then
		return nil
	end
	return index
end

m.has = function(name)
	return m.find(name) and true or false
end

m.select = function(name)
	local slot = c.inventory.find(name)
	if not slot then
		return false
	end
	return turtle.select(slot)
end

m.equip = c.task.wrapLog("c.inventory.equip", function(name)
	if name == c.item.crafting_table and turtle.craft then
		return true
	end
	if not c.inventory.select(name) then
		return false
	end
	local action = turtle.equipLeft
	if name == c.item.diamond_pickaxe then
		action = turtle.equipRight
	end
	return assert(action(), "Somehow failed to equip " .. name)
end)

m.firstEmpty = function()
	local slot = c.range(16):findIndex(function(i)
		return not turtle.getItemDetail(i)
	end)
	if slot == -1 then
		return nil
	end
	return slot
end

m.selectEmpty = function()
	local slot = m.firstEmpty()
	if slot then
		return assert(turtle.select(slot), "Somehow failed to select inventory slot: " .. slot)
	end
	return false
end

m.selectNonEmpty = function()
	local slot = c.range(16):findIndex(function(i)
		return turtle.getItemDetail(i)
	end)
	if slot == -1 then
		return false
	end
	return assert(turtle.select(slot), "Somehow failed to select inventory slot: " .. slot)
end

m.slotsUsed = function()
	return #c.range(16):filter(function(i)
		return turtle.getItemDetail(i)
	end)
end

m.items = function()
	return c.range(16)
		:map(function(i)
			local detail = turtle.getItemDetail(i)
			if detail then
				detail.slot = i
				return detail
			end
			return {}
		end)
		:filter(function(detail)
			return detail.name
		end)
		:reduce(function(acc, detail)
			local cur = acc[detail.name]
			if not cur then
				cur = { total = detail.count, slots = { { slot = detail.slot, count = detail.count } } }
			else
				cur.total = cur.total + detail.count
				cur.slots[#cur.slots + 1] = { slot = detail.slot, count = detail.count }
			end
			acc[detail.name] = cur
			return acc
		end, {})
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
	return true
end

-- Return value signifies whether it moved items
m.moveToEarlySlots = function()
	m.organise()

	local emptyI = 1
	return c.range(16):some(function(i)
		local detail = turtle.getItemDetail(i)
		if detail and emptyI < i then
			turtle.select(i)
			turtle.transferTo(emptyI)

			m.moveToEarlySlots()
			return true
		end
		if detail then
			emptyI = i + 1
		end
		return false
	end)
end

m.dumpLeastImportantSlot = c.task.wrapLog("c.inventory.dumpLeastImportantSlot", function()
	-- TODO: investigate crafting to resolve issues
	-- E.g. craft coal block, redstone block, etc.
	turtle.select(c.goal.leastImportantSlot())
	turtle.drop()
end)

m.ensureFreeSlot = function()
	m.organise()
	if m.slotsUsed() == 16 then
		c.report.warning("Warning: inventory full")
		m.dumpLeastImportantSlot()
	end
end

return m

local m = {}

local skipStash = function()
	c.inventory.organise()
	return c.inventory.slotsUsed() <= 1
end

m.placeChest = function(skip)
	if skip then
		c.report.info("Skipping chest placement for stash")
		return true
	end
	c.dig.up({ smart = true })
	if not c.inventory.select(c.item.chest) then
		c.report.info("No chest in inventory for stashing")
		return false
	end
	if not turtle.placeUp() then
		c.report.info("No success placing stash chest")
		return false
	end
	return true
end

local suckUp = function()
	local success, reason = turtle.suckUp()
	if reason == "No space for items" then
		c.report.warning("Not enough space to pickup stash without dumping")
		c.inventory.dumpLeastImportantSlot()
		success, reason = turtle.suckUp()
	end
	return success
end

m.pickUp = function(skip)
	if skip then
		c.report.info("Skipping chest pickup for stash")
		return true
	end
	c.inventory.organise()

	-- Ensure dumped items are placed in existing slots (namely the chest)
	turtle.select(1)

	while suckUp() do
	end

	if not c.inventory.firstEmpty() then
		c.report.warning("Not enough space to pickup chest without dumping")
		c.inventory.dumpLeastImportantSlot()
	end

	c.dig.up()

	return true
end

-- @param items { name = string, count = number }[]
m.whitelist = c.task.wrapLog("c.stash.whitelist", function(whitelist, task)
	local skipChest = skipStash()

	if not c.stash.placeChest(skipChest) then
		c.report.warning("Cannot stash")
		return false
	end

	local whiteobject = Object.fromEntries(Array(whitelist):map(function(item)
		return { item.name, item.count }
	end))

	c.range(16):forEach(function(slot)
		local detail = turtle.getItemDetail(slot)

		if not detail then
			return
		end

		-- Drop item if not in whitelist
		if not whiteobject[detail.name] then
			turtle.select(slot)
			turtle.dropUp()
			return
		end

		-- Calculate whitelist overflow
		local stashCount = math.max(0, detail.count - whiteobject[detail.name])
		local notStashedCount = detail.count - stashCount

		-- Stash overflow of whitelisted items
		if stashCount > 0 then
			turtle.select(slot)
			if not skipChest then
				assert(turtle.dropUp(stashCount))
			end
		end
		whiteobject[detail.name] = whiteobject[detail.name] - notStashedCount
	end)

	-- Validate stash counts
	local incomplete = Object.entries(whiteobject):some(function(detail)
		local _, count = unpack(detail)
		return count > 0
	end)
	if incomplete then
		c.report.warning("Item counts do not meet stash requirements")
	end

	-- Execute task
	if not incomplete and task and not task() then
		c.report.info("No success executing task while stashed")
	end

	-- Pickup stash
	if not c.stash.pickUp(skipChest) then
		c.report.info("Cannot recover stash")
		return false
	end

	return true, result
end)
return m

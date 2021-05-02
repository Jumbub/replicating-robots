local m = {}

m.placeChest = function()
	if not c.inventory.select(c.item.chest) then
		c.report.info("No chest in inventory for stashing")
		return false
	end
	c.dig.up()
	if not turtle.placeUp() then
		c.report.info("No success placing stash chest")
		return false
	end
	return true
end

m.pickUp = function()
	c.inventory.organise()

	c.range(16):forEach(function()
		return turtle.suckUp()
	end)

	-- TODO: handle this without intervention
	c.task.wrapTryTilTrue("Attempting to suck up stash", function()
		local _, reason = turtle.suckUp()
		return reason ~= "No space for items"
	end)()

	-- TODO: handle this without intervention
	c.task.wrapTryTilTrue("Attempting to select an empty inventory slot", c.inventory.selectEmpty)()

	c.dig.up()

	return true
end

local skip = function(name)
	c.inventory.organise()
	local slotsUsed = c.inventory.slotsUsed()
	assert(slotsUsed > 0, "Somehow you want to stash an inventory with nothing in it: " .. slotsUsed)
	return c.inventory.slotsUsed() == 1 and c.inventory.find(name)
end

m.allButOne = function(name, task)
	local skipStash = skip(name)
	if not skipStash and not c.stash.placeChest() then
		c.report.info("No ability to place chest for stashing")
		return false
	end
	if not skipStash then
		local excepted = false
		c.inventory.organise()
		c.range(16)
			:map(function(i)
				return c.inventory.slotContains(i, name)
			end)
			:forEach(function(except, i)
				if not excepted and except then
					excepted = true
					return
				end
				turtle.select(i)
				turtle.dropUp()
			end)
	end

	local result = task()
	if not result then
		c.report.info("No success executing task while stashed")
	end

	if not skipStash and not c.stash.pickUp() then
		c.report.info("No ability to pick up the stash chest")
		return false
	end

	return true, result
end

return m

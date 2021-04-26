local m = {}

m.placeChest = function()
	if not c.inventory.select("minecraft:chest") then
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

m.pickUpStash = function()
	c.range(16):forEach(function()
		return turtle.suckUp()
	end)

	c.task.recoverable(function()
		local _, reason = turtle.suckUp()
		return reason == "No space for items"
	end, "Expected to be able to pick up all items in stash, please clean out chest")

	c.task.recoverable(
		c.inventory.selectEmpty,
		"Expected to be able to pick up chest, but inventory is full, please remove an item from my inventory"
	)

	c.dig.up()

	return true
end

m.stashExceptSingle = function(name, task)
	if not c.chest.placeChest() then
		c.report.info("No ability to place chest for stashing")
		return false
	end
	local excepted = false
	c.range(16)
		:map(function(i)
			return c.inventory.itemNameContains(i, name)
		end)
		:forEach(function(except, i)
			if not excepted and except then
				excepted = true
				return
			end
			turtle.select(i)
			turtle.dropUp()
		end)

	local result = task()
	if not result then
		c.report.info("No success executing task while stashed")
	end

	if not c.chest.pickUpStash() then
		c.report.info("No ability to pick up the stash chest")
		return false
	end

	return true, result
end

return m

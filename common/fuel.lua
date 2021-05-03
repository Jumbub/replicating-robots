local m = {}

m.itemToFuel = function()
	-- Code relies on this being generated, because I am modifying it's contents via the reference later
	return Object.fromEntries(Array.concat(
		{
			{ c.item.stick, 5 },
			{ c.item.lava_bucket, 1000 },
		},
		c.createEntriesWithValue(15, c.item.all.combustiblePlanks),
		c.createEntriesWithValue(15, c.item.all.combustibleLogs),
		c.createEntriesWithValue(80, c.item.all.coals)
	))
end

m.refuel = function()
	if c.inventory.select(c.item.stick) then
		assert(turtle.refuel(1), "Somehow refueling from stick has failed")
	elseif c.inventory.select(c.item.lava_bucket) then
		assert(turtle.refuel(1), "Somehow refueling from lava bucket has failed")
	elseif c.inventory.select(c.item.all.coals) then
		assert(turtle.refuel(1), "Somehow refueling from coal has failed")
	elseif c.inventory.select(c.item.all.combustiblePlanks) then
		assert(turtle.refuel(1), "Somehow refueling from plank has failed")
	elseif c.inventory.find(c.item.all.combustibleLogs) then
		local successRefueling = c.craft.single(c.item.all.combustibleLogs, 1, function()
			return assert(turtle.refuel(1), "Somehow refueling after crafting plank has failed")
		end)
		if successRefueling then
			return true
		end

		assert(
			c.inventory.select(c.item.all.combustibleLogs),
			"If crafting of plank failed, the log should still be in the inventory"
		)

		return assert(turtle.refuel(1), "Somehow refueling from a log has failed")
	else
		c.report.info("No fuel in inventory")
		return false
	end
	return true
end

m.available = function()
	return turtle.getFuelLevel() + Object.entries(m.itemToFuel()):reduce(function(acc, val)
		local item, value = unpack(val)
		return acc + c.inventory.count(item) * value
	end, 0)
end

m.safeAvailable = function()
	return c.fuel.available() - c.vector.distAtoB(c.gps.getCurrent(), c.location.getHome())
end

-- Destination that wont be in danger of running out of fuel
m.safeDestination = function(location)
	return (
			c.fuel.available()
			- c.vector.distAtoB(c.gps.getCurrent(), location)
			- c.vector.distAtoB(location, c.location.getHome())
		) >= 0
end

-- Check that the move wont be in danger of running out of fuel
m.safeMove = function(direction)
	return c.fuel.safeDestination(c.gpsNext[direction](c.gps.getCurrent()))
end

return m

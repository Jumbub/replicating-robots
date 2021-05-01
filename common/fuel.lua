local m = {}

m.refuel = function()
	if c.inventory.select(c.item.all.coals) then
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
	return turtle.getFuelLevel()
		+ c.inventory.count(c.item.all.combustibleLogs) * 15 * (c.craft.capable() and 4 or 1)
		+ c.inventory.count(c.item.all.combustiblePlanks) * 15
		+ c.inventory.count(c.item.all.coals) * 80
		+ c.inventory.count(c.item.stick) * 5
		+ c.inventory.count(c.item.lava_bucket) * 1000
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

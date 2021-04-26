local m = {}

m.refuel = function()
	if c.inventory.select("coal") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif c.inventory.select("plank") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif c.inventory.find("log") then
		local plank = c.craft.single("log", function()
			return assert(turtle.refuel(1), "Somehow refueling has failed")
		end)
		if plank then
			return true
		end

		c.report.info("No ability to craft planks, resorting to consuming log")
		if not c.inventory.find("log") then
			c.report.info("The plank is no available in the inventory")
			return false
		end

		return assert(turtle.refuel(1), "Somehow refueling has failed")
	else
		c.report.info("No refuel strategy")
		return false
	end
	return true
end

return m

local m = {}

m.refuel = function()
	if c.inventory.select("coal") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif c.inventory.select("plank") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif c.inventory.find("log") then
		local successRefueling = c.craft.single("log", function()
			return assert(turtle.refuel(1), "Somehow refueling after crafting plank has failed")
		end)
		if successRefueling then
			return true
		end

		assert(
			c.inventory.select("log"),
			"If crafting of plank failed, the log should still be in the inventory"
		)

		return assert(turtle.refuel(1), "Somehow refueling has failed")
	else
		c.report.info("No refuel strategy")
		return false
	end
	return true
end

return m

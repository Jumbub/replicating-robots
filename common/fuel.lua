local m = {}

m.refuel = function()
	if c.inventory.select(c.item.all.coal) then
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

return m

require("common")
local inventory = require("common.inventory")
local craft = require("common.craft")
local report = require("common.report")

local refuel = function()
	if inventory.select("coal") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif inventory.select("plank") then
		assert(turtle.refuel(1), "Somehow refueling has failed")
	elseif inventory.find("log") then
		local plank = craft.single("log", function()
			return assert(turtle.refuel(1), "Somehow refueling has failed")
		end)
		if plank then
			return true
		end

		report.no("No ability to craft planks, resorting to consuming log")
		if not inventory.find("log") then
			report.no("The plank is no available in the inventory")
			return false
		end

		return assert(turtle.refuel(1), "Somehow refueling has failed")
	else
		report.no("No refuel strategy")
		return false
	end
	return true
end

return {
	refuel = refuel,
}

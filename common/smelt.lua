local m = {}

local FUEL_FOR_SMELTING_ITEM = 2 + 2 + 2 + 2

m.getData = function()
	return c.state.get("smelt", {
		furnaces = {
			{
				vector = { x = 2, y = -1, z = 1, r = 0 },
				input = c.item.iron_ore,
				output = c.item.iron,
				setup = false,
			},
			{
				vector = { x = 2, y = -1, z = 1, r = 1 },
				input = c.item.sand,
				output = c.item.glass,
				setup = false,
			},
			{
				vector = { x = 2, y = -1, z = 1, r = 2 },
				input = c.item.cobblestone,
				output = c.item.stone,
				setup = false,
			},
		},
	})
end

m.fuelRequired = function(quantity)
	assert(quantity <= 64, "Can only smelt 1 stack at a time")
	c.inventory.organise()

	local itemToFuel = c.fuel.itemToFuel()
	itemToFuel.lava_bucket = nil

	local item = Object.entries(itemToFuel):map(function(entry)
		local item, fuel = unpack(entry)
		return { item, fuel, c.inventory.count(item) }
	end):filter(function(entry)
		return entry[3] > 0
	end):map(function(entry)
		local item, fuelPerItem, count = unpack(entry)

		local itemsPerSecond = fuelPerItem / 10
		local itemsForQuantity = math.ceil(quantity / itemsPerSecond)
		local waste = itemsForQuantity * itemsPerSecond - quantity

		return {
			item = item,
			fuelPerItem = fuelPerItem,
			count = count,
			requiredCount = itemsForQuantity,
			usedFuel = count * fuelPerItem,
			waste = waste,
		}
	end):filter(function(entry)
		return entry.requiredCount <= entry.count
	end):sort(function(a, b)
		return a.waste <= b.waste
	end)[1]

	return item
end

m.requiredFurnaces = function()
	return #Array(m.getData().furnaces):filter(function(location)
		return not location.smelter
	end) - c.inventory.count(c.item.furnace)
end

m.getFurnaceForInput = function(item)
	return Array(m.getData().furnaces):find(function(location)
		return location.input == item
	end)
end

local dropInput = function(quantity)
	assert(c.fuel.safeAvailable() >= 4, "This check should have happened earlier")
	c.move.up()
	c.move.forward()
	turtle.dropDown(quantity)
	c.move.back()
	c.move.down()
end

local dropFuel = function(quantity)
	turtle.drop(quantity)
end

local pickupOutput = function()
	assert(c.fuel.safeAvailable() >= 4, "This check should have happened earlier")
	c.move.down()
	c.move.forward()
	-- Suck up any left-over items from a previous job
	turtle.suckUp()
	while c.inspect.stateIs("lit", true, turtle.inspectUp()) do
		sleep(1)
	end
	turtle.suckUp()
	c.move.back()
	c.move.up()
end

m.item = c.task.wrapLog("c.smelt.item", function(item, quantity)
	if quantity < 0 then
		c.report.warning("Will not craft " .. quantity .. " " .. item)
		return true
	end

	-- Check for item in inventory
	if c.inventory.count(item) < quantity then
		c.report.warning("Inventory does not contain " .. quantity .. " of " .. item .. " for smelting")
		return false
	end

	local furnace = m.getFurnaceForInput(item)

	-- Check item is processable
	if not furnace then
		c.report.warning("Smeltery not available for " .. item)
		return false
	end

	-- Go to furnace
	c.gps.goTo(furnace.vector)

	-- Check for furnace, or place one
	while not c.inspect.is(c.item.furnace, turtle.inspect()) do
		c.report.info("No existing furnace for input")
		while not c.inventory.select(c.item.furnace) do
			c.report.info("No furnaces in inventory required for smelting")
			while c.inventory.count(c.item.cobblestone) < 8 do
				c.report.info("Not enough cobble to create missing furnace")
				c.mine.til(function()
					return c.inventory.count(c.item.cobblestone) < 8
				end)
			end
			c.craft.donut(c.item.cobblestone, 1)
		end
		c.dig.forward()
		turtle.place()
	end

	-- Calculate required fuel
	local fuel = m.fuelRequired(quantity)
	c.report.info("Fuel calculation complete", fuel)

	-- Harvest logs til we can smelt quantity
	-- while not fuel or c.fuel.safeAvailable() - fuel.usedFuel - FUEL_FOR_SMELTING_ITEM < 0 do
	-- 	local required = math.max((fuel.usedFuel + FUEL_FOR_SMELTING_ITEM) - c.fuel.safeAvailable(), 0)

	-- 	-- This algorithm for determining when to stop is unbelievably conservative
	-- 	local start = c.inventory.count(c.item.all.logs)
	-- 	c.tree.harvestTil(function()
	-- 		return (c.inventory.countSingleHighest(c.item.all.logs) - start) * 6 >= quantity + required / 10
	-- 	end)

	-- 	fuel = m.fuelRequired(quantity)
	-- end

	-- Harvest logs til we can perform task
	-- while c.fuel.safeAvailable() - fuel.usedFuel - FUEL_FOR_SMELTING_ITEM > 0 do
	-- 	-- The "+ 50" is just a random buffer to prevent excessive trips
	-- 	local required = c.vector.distToHome() * 2 + FUEL_FOR_SMELTING_ITEM + fuel.usedFuel + 50
	-- 	c.tree.harvestTil(function()
	-- 		return c.fuel.available() - required > 0
	-- 	end)
	-- end

	-- Wait for existing item to finish smelting
	while c.inspect.stateIs("lit", true, turtle.inspect()) do
		c.report.info("Waiting for existing materials to smelt", fuel)
		sleep(5)
	end

	-- Fuel up
	c.inventory.select(fuel.item)
	dropFuel(fuel.requiredCount)

	-- Add input
	c.inventory.select(item)
	dropInput(quantity)

	-- Wait for output
	pickupOutput()

	return true
end)

return m

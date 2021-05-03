local m = {}

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

local dropItem = function(quantity)
	if c.fuel.safeAvailable() < 4 then
		return false
	end
	c.move.up()
	c.move.forward()
	turtle.dropDown(quantity)
	c.move.back()
	c.move.down()
end

local dropFuel = function(ticks)
	turtle.drop(quantity)
end

local suckItem = function(quantity)
	c.move.down()
	c.move.forward()
	if c.fuel.safeAvailable() >= 4 then
		turtle.dropUp()
	end
	c.move.down()
	c.move.forward()
	turtle.suckUp()
	c.move.back()
	c.move.up()
end

m.item = c.task.wrapLog("c.smelt.item", function(item, quantity)
	-- Check for item in inventory
	if not c.inventory.count(item) >= quantity then
		c.report.warning("Inventory does not contain " .. quantity .. " of " .. item .. " for smelting")
		return false
	end

	local furnace = m.getFurnaceForInput(item)

	-- Check item is processable
	if not furnace then
		c.report.warning("Cannot smelt " .. item)
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
		end
		c.dig.forward()
		turtle.place()
	end

	-- Calculate required coal
	local req = fuelForItem(item) * quantity
	if c.fuel.safeAvailable() - req then
	end

	-- Wait for existing item to finish smelting
	while c.inspect.stateIs("lit", true, turtle.inspect()) do
		sleep(1)
	end

	return true
end)

m.autoOnce = function()
end

m.autoTil = function()
end

return m

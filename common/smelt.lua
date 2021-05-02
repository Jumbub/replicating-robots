local m = {}

m.getData = function()
	return c.state.get("smelt", {
		locations = {
			{
				vector = { x = 0, y = -2, z = 0, r = 0 },
				input = c.item.iron_ore,
				output = c.item.iron,
				furnace = false,
			},
			{
				vector = { x = 0, y = -2, z = 0, r = 1 },
				input = c.item.sand,
				output = c.item.glass,
				furnace = false,
			},
			{
				vector = { x = 0, y = -2, z = 0, r = 2 },
				input = c.item.cobblestone,
				output = c.item.stone,
				furnace = false,
			},
		},
	})
end

m.requiredFurnaces = function()
	return #Array(m.getData().locations):filter(function(location)
		return not location.smelter
	end) - c.inventory.count(c.item.furnace)
end

m.getLocationForInput = function(item)
	return Array(m.getData().locations):find(function(location)
		return location.input == item
	end)
end

m.shouldSmelt = function(item, quantity)
	-- Check for item in inventory
	if not c.inventory.has(item) then
		c.report.info("Cannot smelt an item you dont have")
		return false
	end

	location = m.getLocationForInput(item)

	-- Check for enough fuel to burn quantity
	if c.safeDestination(location.vector) then
	end

	-- Check if a furnace exists
	if not m.getLocationForInput(item).furnace then
		-- Craft required furnace
		if not (c.inventory.count(c.item.cobblestone) >= 8 and c.craft.capable()) then
			c.report.info("Cannot craft furnace required to smelt item", {
				item = item,
				availStone = c.inventory.count(c.item.cobblestone),
				craft = c.craft.capable(),
			})
			return false
		end
	end

	return true
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
	if not c.inventory.has(item) then
		c.report.info("Cannot smelt an item you dont have: " .. item)
		return false
	end

	local location = m.getLocationForInput(item)
	if not location then
		c.report.info("Item does not exist in smelter locations: " .. item)
	end

	c.gps.goTo(location.vector)
	if not c.inventory.select(item) then
		c.report.info("Item not in inventory anymore: " .. item)
		return false
	end
	if not location.furnace then
		if not c.inventory.select(c.item.furnace) then
			c.report.info("Cannot craft required furnace: " .. item)
			return false
		end
		c.dig.forward()
		assert(turtle.place(), "Failed to place furnace")
	end

	return true
end)

m.autoOnce = function()
end

m.autoTil = function()
end

return m

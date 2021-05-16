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

local dropInput = function(item, quantity)
	assert(c.fuel.safeAvailable() >= 4, "This check should have happened earlier")
	c.move.up()
	c.move.forward()

	c.inventory.ensureFreeSlot()
	turtle.suckDown()

	-- Drop input
	c.inventory.select(item)
	turtle.dropDown(quantity)

	c.move.back()
	c.move.down()
	return true
end

local dropFuel = function(item, quantity)
	c.inventory.ensureFreeSlot()
	turtle.suck()

  assert(c.inventory.count(item) >= quantity)

	-- Drop fuel
	c.inventory.select(item)
  turtle.drop(quantity)
	return true
end

local pickupOutput = function()
	assert(c.fuel.safeAvailable() >= 4, "This check should have happened earlier")
	c.move.down()
	c.move.forward()

	-- Pickup output
	while c.inspect.stateIs("lit", true, turtle.inspectUp()) do
		sleep(1)
	end
  c.inventory.ensureFreeSlot()
	turtle.suckUp()

	c.move.back()
	c.move.up()
	return true
end

m.item = c.task.wrapLog("c.smelt.item", function(item, quantity, async)
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
		c.dig.forward()
		c.report.info("No existing furnace for input")
		while not c.inventory.select(c.item.furnace) do
			c.report.info("No furnaces in inventory required for smelting")
			while c.inventory.count(c.item.cobblestone) < 8 do
				c.report.info("Not enough cobble to create missing furnace")
				c.mine.til(function()
					return c.inventory.count(c.item.cobblestone) >= 8
				end)
			end
			c.craft.recipe(c.recipe[c.item.furnace], 1)
		end
		turtle.place()
	end

	-- Ensure does not try to refuel under furnace
	if c.fuel.safeAvailable() - FUEL_FOR_SMELTING_ITEM <= 0 then
		c.fuel.refuel()
    -- TODO: make this better by harvesting if refueling fails
	end

	-- Calculate required fuel
	local fuel = m.fuelRequired(quantity)
	c.report.info("Fuel calculation complete", fuel)

  -- If the fuel can be converted to planks, do so
  local plank = c.item.logToPlank(fuel.item)
  if plank then
      assert(c.craft.recipe(c.recipe[plank], fuel.requiredCount * 4))
      fuel.item = plank
      fuel.requiredCount = 4 * fuel.requiredCount
  end

	-- Wait for existing item to finish smelting
	while c.inspect.stateIs("lit", true, turtle.inspect()) do
		c.report.info("Waiting for existing materials to smelt", fuel)
		sleep(1)
	end

	-- Fuel up
	dropFuel(fuel.item, fuel.requiredCount)

	-- Add input
	dropInput(item, quantity)

	-- If async, return a command for picking up output
	if async then
		local pos = c.gps.getCurrent()
		return true, function()
			c.gps.goTo(pos)
			pickupOutput()
		end
	end

	-- If sync, pickup output
	pickupOutput()
	return true
end)

-- @var items {name: string, count: number}
m.items = function(items)
	return Array(items)
		:map(function(item)
			local success, pickup = m.item(item.name, item.count, true)
			if not success then
				c.report.error("Failed to smelt " .. item.count .. " " .. item.name .. "s")
				return { success }
			end
			return { success, pickup }
		end)
		:map(function(detail)
			local success, pickup = unpack(detail)
			if success then
				return pickup()
			else
				return "Failed"
			end
		end)
end

return m

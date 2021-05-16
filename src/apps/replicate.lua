require("lib")
require("src.common")

local main = function()
	assert(c.state.reset())

	assert(c.tree.chop({ first = true }))
	assert(c.tree.harvestOnce())

	while not c.goal.achieved(Array.concat(c.goal.GOALS.scan, c.goal.GOALS.mine)) do
		-- Scan
		c.scan.til(function()
			return c.goal.achieved(c.goal.GOALS.scan)
		end)

		-- Mine
		c.mine.til(function()
      c.report.info('Inventory status', c.inventory.items())
			return c.goal.achieved(c.goal.GOALS.mine)
		end)

		sleep(1) -- Prevent spam loop when code is bugged bugs
	end

	-- Smelt required items
	local furni = c.inventory.count(c.item.furnace)
	assert(c.craft.recipe(c.recipe[c.item.furnace], math.max(0, 3 - furni)))
	assert(c.smelt.items({
		{ name = c.item.iron_ore, count = 14 },
		{ name = c.item.cobblestone, count = 14 },
		{ name = c.item.sand, count = 6 },
	}))

	-- Craft turtles
	assert(c.craft.recipe(c.recipe[c.item.glass_pane], 2))
	assert(c.craft.recipe(c.recipe[c.item.computer_normal], 2))
	local planki = c.inventory.count(c.item.all.combustiblePlanks)
	assert(c.craft.recipe(c.recipe.plank, math.max(0, 42 - planki)))
	assert(c.craft.recipe(c.recipe[c.item.chest], 3))
	assert(c.craft.recipe(c.recipe[c.item.turtle_normal], 2))
	assert(c.craft.recipe(c.recipe[c.item.stick], 5))
	assert(c.craft.recipe(c.recipe[c.item.diamond_pickaxe], 2))
	assert(c.craft.recipe(c.recipe[c.item.crafting_table], 2))
	-- Diamond picks don't stack, so you can't craft them together
	assert(c.craft.recipe(c.recipe.crafty_miney_turtle_normal, 1))
	assert(c.craft.recipe(c.recipe.crafty_miney_turtle_normal, 1))
	assert(c.craft.recipe(c.recipe[c.item.sign], 1))

	-- Go to chest location
	assert(c.gps.goTo({ x = 0, y = 0, z = -4, r = 2 }))

	-- Place turtles in chest
	c.turn.around()
	assert(c.inventory.select(c.item.chest))
	assert(turtle.placeUp())
	c.turn.around()
	assert(c.inventory.select(c.item.turtle_normal))
	assert(turtle.dropUp())

	-- Place completion sign
	assert(c.move.forward({ times = 2 }))
	c.move.up()
	c.turn.around()
	assert(c.inventory.select(c.item.all.signs))
	assert(turtle.place("Complete"))
	c.move.down()
	assert(c.move.forward({ times = 2 }))
	c.turn.around()

	-- Done
	c.report.warning("Wait, it actually worked...")
	require("lib/screensaver")
end

local success, result = pcall(main)

if not success then
	c.report.error(result)
end

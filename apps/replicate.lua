require("lib")
require("common")

local gatherResources = function()
	_G.GATHER_STACK = 0
	while not c.goal.achieved(Array.concat(c.goal.SCAN_GOAL, c.goal.MINE_GOAL)) do
		if not c.goal.achieved(c.goal.SCAN_GOAL) then
			c.scan.til(function()
				return c.goal.achieved(c.goal.SCAN_GOAL)
			end)
		elseif not c.goal.achieved(c.goal.MINE_GOAL) then
			c.mine.til(function()
				return c.goal.achieved(c.goal.MINE_GOAL)
			end)
		end

		-- Abort bad loops
		_G.GATHER_STACK = _G.GATHER_STACK
		if _G.GATHER_STACK > 20 then
			error("The gather loop has repeated 20 times, aborting")
		end
	end
end

local main = function()
	c.state.reset()

	c.tree.chop({ first = true })
	c.tree.harvestOnce()

	gatherResources()

	-- Smelt required items
	local furni = c.inventory.count(c.item.furnace)
	c.craft.recipe(c.recipe[c.item.furnace], math.max(0, 3 - furni))
	c.smelt.items({
		{ name = c.item.iron_ore, count = 14 },
		{ name = c.item.cobblestone, count = 14 },
		{ name = c.item.sand, count = 6 },
	})

	-- Craft turtles
	c.craft.recipe(c.recipe[c.item.glass_pane], 2)
	c.craft.recipe(c.recipe[c.item.computer_normal], 2)
	local planki = c.inventory.count(c.item.all.combustiblePlanks)
	c.craft.recipe(c.recipe.plank, math.max(0, 42 - planki))
	c.craft.recipe(c.recipe[c.item.chest], 3)
	c.craft.recipe(c.recipe[c.item.turtle_normal], 2)
	c.craft.recipe(c.recipe[c.item.stick], 5)
	c.craft.recipe(c.recipe[c.item.diamond_pickaxe], 2)
	c.craft.recipe(c.recipe[c.item.crafting_table], 2)
	-- Diamond picks don't stack, so you can't craft them together
	c.craft.recipe(c.recipe.crafty_miney_turtle_normal, 1)
	c.craft.recipe(c.recipe.crafty_miney_turtle_normal, 1)
	c.craft.recipe(c.recipe[c.item.sign], 1)

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
	c.move.forward({ times = 2 })
	c.move.up()
	c.turn.around()
	assert(c.inventory.select(c.item.all.signs))
	assert(turtle.place("Complete"))
	c.move.down()
	c.move.forward({ times = 2 })
	c.turn.around()

	-- Done
	c.report.warning("Wait, it actually worked...")
	require("lib/screensaver")
end

local success, result = pcall(main)

if not success then
	c.report.error(result)
end

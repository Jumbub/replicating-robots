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

	c.smelt.items({
		{ name = c.item.iron_ore, count = 14 },
		{ name = c.item.cobblestone, count = 14 },
		{ name = c.item.sand, count = 6 },
	})

	c.craft.recipe(c.recipe.glass_pane, 2)
	c.craft.recipe(c.recipe.chest, 2)
	c.craft.recipe(c.recipe.computer_normal, 2)
	c.craft.recipe(c.recipe.turtle_normal, 2)
end

local success, result = pcall(main)

if success then
	c.report.info(result)
	c.report.warning("Wait, it actually worked...")
else
	c.report.error(result)
end

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
	c.smelt.item(c.item.iron_ore, 14)

	gatherResources()
	c.smelt.item(c.item.cobblestone, 14)

	gatherResources()
	c.smelt.item(c.item.sand, 6)

	gatherResources()
	-- c.craft.fence(c.item.glass, 1)
end

local success, result = pcall(main)

if success then
	c.report.info(result)
	c.report.warning("Wait, it actually worked...")
else
	c.report.error(result)
end

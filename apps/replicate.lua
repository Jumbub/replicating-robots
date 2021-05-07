require("lib")
require("common")

local main = function()
	c.state.reset()

	c.scan.til(function()
		return false
	end)
	-- c.mine.til(function()
	-- 	return false
	-- end)
	-- c.smelt.item(c.item.iron_ore, 9)

	-- c.tree.chop({ first = true })
	-- c.tree.harvestOnce()
	-- c.scan.ground(1)
end

local success, result = pcall(main)

if not success then
	c.report.error(result)
else
	c.report.warning("Wait, it actually worked...")
end

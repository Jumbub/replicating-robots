require("lib")
require("common")

local main = function()
	c.state.reset()

	c.mine.til(function()
		return false
	end)
	-- c.smelt.item(c.item.iron_ore, 9)

	-- c.tree.chop({ first = true })
	-- c.tree.harvestOnce()
	-- c.scan.ground(1)
	-- c.mineVertical.vertical(1)
end

main()

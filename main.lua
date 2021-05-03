require("lib")
require("common")

local main = function()
	c.state.reset()

	c.smelt.item(c.item.iron_ore, 9)

	-- c.tree.chop({ first = true })
	-- c.tree.harvestOnce()
	-- c.scan.ground(1)
	-- c.mine.vertical(1)
end

main()

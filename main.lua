require("lib")
require("common")

local main = function()
	c.state.reset()

	c.tree.chop({ first = true })
	c.tree.harvestOnce()
	c.scan.ground(1)
	c.mine.vertical(1)
end

main()

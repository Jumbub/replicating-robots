require("lib")
require("common")

c.state.reset()
-- c.tree.chop({ first = true })
c.plant.harvestTrees(function()
	return c.fuel.available() > 100
end)
-- c.scan.ground(4)
-- c.mine.vertical(6)

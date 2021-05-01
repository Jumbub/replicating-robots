local m = {}

m.trees = function()
	if not c.inventory.has(c.item.all.saplings) then
		return
	end
	c.nTimes(4, function()
		c.tree.chop()
		if c.inventory.select(c.item.all.saplings) then
			local planted = turtle.place()
			if not planted and not turtle.detect() then
				c.report.warning("Currently no support for planting saplings without base dirt")
			end
		end
		c.turn.right()
	end)
end

m.harvestTrees = function(til)
	c.report.info("Going to tree harvesting location")
	c.gps.goHome()

	-- Run once, if no til provided
	local x = 0
	til = til or function()
		x = x + 1
		return x == 2
	end

	while not til() do
		c.report.info("[ ] Tree harvest cycle")

		c.plant.trees()

		if til() then
			c.report.info("[x] Harvesting trees")
			break
		end

		c.report.info("[x] Tree harvest cycle")
		sleep(10)
	end
end

return m

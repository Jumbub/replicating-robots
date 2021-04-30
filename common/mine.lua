local m = {}

m.patch = function()
end

m.spin = function()
	c.nTimes(4, function()
		if c.inspect.shouldDig(turtle.inspect()) then
			c.dig.forward()
		end
		c.turn.right()
	end)
end

local squigle = function()
	c.move.forward({ times = 2 })
	c.turn.right()
	c.move.forward()
	c.turn.left()
end

m.singleVertical = function()
	c.report.info("Started vertically mining down")
	local depth = 0
	while c.move.down() do
		m.spin()
		depth = depth + 1
	end
	c.report.info("Reach bottom of vertical mine")
	c.move.up({ times = 6 }) -- out of bedrock zone
	depth = depth - 6
	squigle()
	c.report.info("Started vertically mining up")
	assert(depth >= 0, "Somehow the mining depth is negative: " .. depth)
	while depth > 0 do
		c.move.up()
		m.spin()
		depth = depth - 1
	end
	c.report.info("Completed 2 vertical mines")
end

local alternateAB = function(a, b, n)
	c.nTimes(n, function()
		a()
		local bBackup = b
		b = a
		a = bBackup
	end)
end

-- local test = function()
-- 	c.move.down()
-- 	c.move.up()
-- 	squigle()
-- 	c.move.down()
-- 	c.move.up()
-- end

m.vertical = function(edges)
	c.nTimes(edges, function(edge)
		if (edge + 2) % 4 == 0 then
			alternateAB(squigle, m.singleVertical, math.ceil(edge / 2))
		else
			alternateAB(m.singleVertical, squigle, math.ceil(edge / 2))
		end
		c.turn.right()
	end)
end

return m

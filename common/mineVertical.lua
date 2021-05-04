local m = {}

m.spin = function()
	c.forI(4, function(i)
		local success, block = turtle.inspect()
		if c.inspect.shouldDig(success, block) then
			c.report.info("Found something worth mining: " .. block.name)
			c.dig.forward()
		end
		if i ~= 4 then
			c.turn.right()
		end
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

	c.report.info("Reached bottom of vertical mine")
	-- Move out of bedrock zone
	c.forI(4, function()
		m.spin()
		c.move.up()
		depth = depth - 1
	end)

	squigle()
	c.report.info("Started vertically mining up")
	assert(depth >= 0, "Somehow the mining depth is negative: " .. depth)
	while depth > 0 do
		c.move.up()
		m.spin()
		depth = depth - 1
	end

	c.state.updateKey("mineVertical", function(state)
		state.last = c.gps.getCurrent()
		return state
	end)
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

m.vertical = c.task.wrapLog("c.mineVertical.vertical", function(position, )
	c.forI(edges, function(edge)
		if (edge + 2) % 4 == 0 then
			alternateAB(squigle, m.singleVertical, math.ceil(edge / 2))
		else
			alternateAB(m.singleVertical, squigle, math.ceil(edge / 2))
		end
		c.turn.right()
	end)

	m.gps.goHome()
end)

m.next = c.task.wrapLog('c.mineVertical.next', function()
end)

return m

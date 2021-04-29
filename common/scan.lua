local m = {}

local inspection = function()
	if c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		c.tree.chop()
	end
	if c.inspect.shouldDig(turtle.inspect()) then
		c.dig.forward()
	end
end

-- Susceptiable to falling into caves. Never to be seen again.
m.forward = function(times)
	if times < 1 then
		return
	end
	while not c.move.forward({ destroy = false }) do
		c.move.up()
	end
	while not turtle.detectDown() do
		c.move.down()
	end
	inspection()
	c.turn.right()
	inspection()
	c.turn.around()
	inspection()
	c.turn.right()

	m.forward(times - 1)
end

local squigle = function()
	c.turn.right()
	m.forward(1)
	c.turn.left()
	m.forward(2)
end

m.ground = function(loops)
	if loops <= 0 then
		c.report.warning("Poor loops argument to ground scan function: " .. loops)
		return
	end

	c.mine.spin()

	c.report.info("Starting initial custom loop")
	m.forward(2)
	c.turn.right()
	m.forward(3)
	c.turn.right()
	m.forward(4)
	c.turn.right()
	m.forward(6)
	c.turn.right()
	m.forward(5)
	if loops <= 1 then
		return
	end

	c.nTimes(loops - 1, function(loopI)
		c.report.info("Starting pattern loop n:" .. loopI)
		c.nTimes(4, function(edge)
			c.nTimes(loopI, squigle)
			c.turn.right()
			local offset = (loopI - 1) * 3
			if edge == 1 then
				m.forward(6 + offset) -- 9
			elseif edge == 2 then
				m.forward(7 + offset) -- 10
			elseif edge == 3 then
				m.forward(9 + offset) -- 12
			elseif edge == 4 then
				m.forward(8 + offset) -- 11
			end
		end)
	end)
end

return m

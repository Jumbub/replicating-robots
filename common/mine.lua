local m = {}

m.down = function()
	local depth = 0
	while c.move.down() do
		c.nTimes(4, function()
			if c.inspect.requireResource(turtle.inspect()) then
				c.dig.forward()
			end
			c.turn.right()
		end)
		depth = depth + 1
	end
	c.move.up({ times = depth })
end

return m

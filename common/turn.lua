local m = {}

m.right = function()
	assert(turtle.turnRight(), "Somehow the turtle failed to turn right")
end
m.left = function()
	assert(turtle.turnLeft(), "Somehow the turtle failed to turn left")
end
m.around = function()
	c.turn.right()
	c.turn.right()
end

return m

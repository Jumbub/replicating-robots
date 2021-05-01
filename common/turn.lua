local m = {}

m.right = function()
	assert(turtle.native.turnRight(), "Somehow the turtle failed to turn right")
	c.relativeGps.turnRight()
end
m.left = function()
	assert(turtle.native.turnLeft(), "Somehow the turtle failed to turn left")
	c.relativeGps.turnLeft()
end
m.around = function()
	c.turn.right()
	c.turn.right()
end

return m

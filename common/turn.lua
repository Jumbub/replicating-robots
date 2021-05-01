local m = {}

m.right = function()
	assert(turtle.native.turnRight(), "Somehow the turtle failed to turn right")
	c.gpsRelative.turnRight()
end
m.left = function()
	assert(turtle.native.turnLeft(), "Somehow the turtle failed to turn left")
	c.gpsRelative.turnLeft()
end
m.around = function()
	c.turn.right()
	c.turn.right()
end

return m

local m = {}

m.forward = function(cur, times)
	times = times or 1

	local next = c.vector.clone(cur)
	local axis = cur.r % 2 == 0 and "z" or "x"
	next[axis] = cur[axis] + (cur.r <= 1 and 1 or -1) * times
	return next
end
m.back = function(cur, times)
	return m.forward(cur, -(times or 1))
end

m.up = function(cur, times)
	local next = c.vector.clone(cur)
	next.y = cur.y + (times or 1)
	return next
end
m.down = function(cur, times)
	return m.up(cur, -(times or 1))
end

m.turnRight = function(cur, times)
	local next = c.vector.clone(cur)
	next.r = (cur.r + (times or 1)) % 4
	return cur
end
m.turnLeft = function(cur, times)
	return m.turnRight(cur, -(times or 1))
end

return m

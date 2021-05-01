local m = {}

local ID = os.getComputerID()
local STATE_KEY = "relativeGps"
local DEFAULT = { x = 0, y = 0, z = 0, r = 0 }

local update = function(action)
	c.state.updateKey(STATE_KEY, DEFAULT, action)
end

m.forward = function(times)
	times = times or 1
	update(function(cur)
		local axis = cur.r % 2 == 0 and "z" or "x"
		cur[axis] = cur[axis] + (cur.r <= 1 and 1 or -1) * times
		return cur
	end)
end
m.back = function(times)
	m.forward(-(times or 1))
end

m.up = function(times)
	update(function(cur)
		cur.y = cur.y + (times or 1)
		return cur
	end)
end
m.down = function(times)
	m.up(-(times or 1))
end

m.turnRight = function(times)
	update(function(cur)
		cur.r = (cur.r + (times or 1)) % 4
		return cur
	end)
end
m.turnLeft = function(times)
	m.turnRight(-(times or 1))
end

m.current = function()
	return c.state.get(STATE_KEY, DEFAULT)
end

return m

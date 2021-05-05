local m = {}

local STATE_KEY = "gpsRelative"
local DEFAULT = { x = 0, y = 0, z = 0, r = 0 }

local update = function(action)
	c.state.update(STATE_KEY, DEFAULT, action)
end

m.forward = function(times)
	update(function(cur)
		return c.gpsNext.forward(cur, times)
	end)
end
m.back = function(times)
	m.forward(-(times or 1))
end

m.up = function(times)
	update(function(cur)
		return c.gpsNext.up(cur, times)
	end)
end
m.down = function(times)
	m.up(-(times or 1))
end

m.turnRight = function(times)
	update(function(cur)
		return c.gpsNext.turnRight(cur, times)
	end)
end
m.turnLeft = function(times)
	m.turnRight(-(times or 1))
end

m.getCurrent = function()
	return c.state.get(STATE_KEY, DEFAULT)
end

return m

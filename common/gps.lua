local m = {}

m.noTravelHeights = function()
	-- inclusive
	local heights = c.state.get("noTravelHeights", { top = 7, bottom = -2 })
	return heights.top, heights.bottom
end

m.offsetToTravelHeight = function(cur)
	local top, bottom = m.noTravelHeights()
	if cur.y < bottom or cur.y > top then
		return 0
	end
	local toTop = math.abs(top - cur.y)
	local toBottom = math.abs(bottom - cur.y)
	if toTop < toBottom then
		return toTop
	else
		return -toBottom
	end
end

m.goToTravelHeight = function(cur)
	c.move.up({ times = m.offsetToTravelHeight(cur) })
end

m.goTo = function(to, options)
	options = options or {}
	local safe = options.safe == nil or options.safe

	local cur = c.gps.getCurrent()
	c.report.info("gps.goTo", cur, to, c.vector.distAtoB(cur, to))

	if safe and not c.fuel.safeDestination(to) then
		c.report.warning("Not enough fuel to go to location")
		return false
	end

	if safe and c.vector.horDistAtoB(cur, to) > 0 then
		-- Move down to a level that avoid "trampling"
		m.goToTravelHeight(cur)
	end
	m.goToAxis("z", to.z)
	m.goToAxis("x", to.x)
	m.goToAxis("y", to.y)
	m.face("z")
	c.nTimes(to.r or 0, function()
		c.turn.right()
	end)
end

m.goToAxis = function(axis, to)
	local cur = c.gps.getCurrent()
	if axis == "y" then
		c.move.up({ times = to - cur.y })
	elseif axis == "z" then
		m.face("z")
		c.move.forward({ times = to - cur.z })
	elseif axis == "x" then
		m.face("x")
		c.move.forward({ times = to - cur.x })
	else
		error("Somehow I am supposed to travel along this axis: " .. axis)
	end
end

m.face = function(axis)
	local cur = c.gps.getCurrent()
	if axis == "z" then
		if cur.r == 1 then
			c.turn.left()
		else
			c.nTimes(4 - cur.r, c.turn.right)
		end
	elseif axis == "x" then
		if cur.r == 0 then
			c.turn.right()
		elseif cur.r == 2 then
			c.turn.left()
		elseif cur.r == 3 then
			c.turn.around()
		end
	else
		error("Somehow I am supposed to face this axis: " .. axis)
	end
end

m.getCurrent = function()
	return c.gpsRelative.getCurrent()
end

m.goHome = function(options)
	c.gps.goTo(c.location.getHome(), options)
end

return m

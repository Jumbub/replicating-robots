local m = {}

m.noTravelHeights = function()
	-- Numbers are exclusive
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

m.goTo = c.task.wrapLog("c.gps.goTo", function(to, options)
	assert(to)
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
	m.faceR(to.r)

	return true
end)

m.goToAxis = function(axis, to)
	local cur = c.gps.getCurrent()
	if cur[axis] == to then
		return
	end
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

m.faceR = function(tar)
	local cur = c.gps.getCurrent()
	local left = (cur.r - tar) % 4
	local right = (tar - cur.r) % 4
	if left < right then
		c.nTimes(left, c.turn.left)
	else
		c.nTimes(right, c.turn.right)
	end
end

m.face = function(axis)
	if axis == "z" then
		m.faceR(0)
	elseif axis == "x" then
		m.faceR(1)
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

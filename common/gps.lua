local m = {}

m.goTo = function(to)
	local cur = c.relativeGps.current()
	c.report.info("gps.goTo", cur, to)

	local diff = c.vector.fromAtoB(cur, to)

	c.nTimes((4 - cur.r) % 4, c.turn.right)
	c.move.forward({ times = diff.z })
	c.move.up({ times = diff.y })
	c.turn.right()
	c.move.forward({ times = diff.x })
	c.turn.left()
end

m.current = function()
	return c.relativeGps.current()
end

return m

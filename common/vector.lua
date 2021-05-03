local m = {}

m.fromAtoB = function(a, b)
	return { x = b.x - a.x, y = b.y - a.y, z = b.z - a.z }
end

m.horDistAtoB = function(a, b)
	assert(a)
	assert(b)
	local dist = m.fromAtoB(a, b)
	return math.abs(dist.x) + math.abs(dist.z)
end

-- The "safe" GPS distance
m.distAtoB = function(a, b)
	assert(a)
	assert(b)
	local dist = m.fromAtoB(a, b)
	local travelHeightOffset = 0
	if m.horDistAtoB(a, b) > 0 then
		travelHeightOffset = math.abs(c.gps.offsetToTravelHeight(a)) + math.abs(c.gps.offsetToTravelHeight(b))
	end
	return math.abs(dist.x) + math.abs(dist.y) + math.abs(dist.z) + travelHeightOffset
end

m.clone = function(a)
	return { x = a.x, y = a.y, z = a.z, r = a.r or 0 }
end

m.distToHome = function()
	return m.distAtoB(c.gps.getCurrent(), c.location.getHome())
end

return m

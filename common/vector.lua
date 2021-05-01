local m = {}

m.fromAtoB = function(a, b)
	return { x = b.x - a.x, y = b.y - a.y, z = b.z - a.z }
end

m.distAtoB = function(a, b)
	local dist = m.fromAtoB(a, b)
	return math.abs(dist.x) + math.abs(dist.y) + math.abs(dist.z)
end

return m

local m = {}

m.chopRecursive = function(height)
	if not c.inspect.hasTag("minecraft:logs", turtle.inspectUp()) then
		return c.leaf.collect(height)
	end

	c.move.up({ destroy = true })

	c.tree.chopRecursive(height + 1)
end

m.chop = function()
	if not c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		return false
	end

	c.move.forward({ destroy = true })

	c.tree.chopRecursive(0)

	c.move.back({ destroy = true })
	return true
end

return m

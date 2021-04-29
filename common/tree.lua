local m = {}

m.chopRecursive = function(height, options)
	if not c.inspect.hasTag("minecraft:logs", turtle.inspectUp()) then
		return c.leaf.collect(height)
	end

	if height == 2 and options.firstTask then
		c.report.info("Crafting a chest because this the first tree task")
		assert(turtle.select(1), "Somehow this failed")
		assert(turtle.refuel(3), "First task: there should be 3 planks in the first inventory")
		assert(c.craft.single("log", 2), "First task: there should always be the ability to craft 8 planks")
		assert(c.craft.donut("plank", 1), "First task: there should always be the ability to craft 1 chest")
	end

	c.move.up()

	c.tree.chopRecursive(height + 1, options)
end

m.chop = function(options)
	c.report.info("Starting tree chopping task")
	options = options or {}
	if not c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		return false
	end

	c.move.forward()

	c.tree.chopRecursive(0, options)

	c.move.back()
	return true
end

return m

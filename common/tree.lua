local m = {}

m.chopRecursive = function(height, options)
	if not c.inspect.hasTag("minecraft:logs", turtle.inspectUp()) then
		return c.leaf.collect(height)
	end

	-- Special case to handle an early complex chest craft
	if height == 2 and options.first then
		c.report.info("Crafting a chest because this the first tree task")
		assert(turtle.select(1), "Somehow this failed")
		assert(turtle.refuel(3), "First task: there should be 3 planks in the first inventory")
		assert(
			c.craft.single(c.item.all.combustibleLogs, 2),
			"First task: there should always be the ability to craft 8 planks"
		)
		assert(
			c.craft.donut(c.item.all.combustiblePlanks, 1),
			"First task: there should always be the ability to craft 1 chest"
		)
	end

	c.move.up()

	c.tree.chopRecursive(height + 1, options)
end

m.chop = function(options)
	options = options or {}
	if not c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		return false
	end
	c.report.info("Starting tree chopping task")

	c.move.forward()
	local basePos = c.gps.getCurrent()

	-- Chop tree above
	c.tree.chopRecursive(0, options)

	-- Chop tree below
	while c.inspect.hasTag("minecraft:logs", turtle.inspectDown()) do
		c.move.down()
	end

	c.gps.goTo(basePos)
	c.move.back()

	return true
end

return m

local m = {}

local specialFirstTree = function()
	c.report.info("Crafting a chest because this the first tree task")
	assert(turtle.select(16), "Somehow this failed")
	assert(turtle.refuel(), "First task: there should be planks in slot 16")
	assert(
		c.craft.recipe(c.recipe.plank, 8),
		"First task: there should always be the ability to craft 8 planks"
	)
	assert(
		c.craft.recipe(c.recipe[c.item.chest], 1),
		"First task: there should always be the ability to craft 1 chest"
	)
end

m.chopRecursive = function(height, options)
	if not c.inspect.hasTag("minecraft:logs", turtle.inspectUp()) then
		return c.leaf.collect(height)
	end

	-- Special case to handle an early complex chest craft
	if height == 2 and options.first then
		specialFirstTree()
	end

	c.move.up({ destroy = true })

	c.tree.chopRecursive(height + 1, options)
end

m.chop = c.task.wrapLog("c.tree.chop", function(options)
	options = options or {}
	if not c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		c.report.info("Nothing to chop")
		return false
	end

	c.move.forward()
	local basePos = c.gps.getCurrent()

	-- Clear bottom of tree
	local height = 0
	while c.inspect.shouldChop(turtle.inspectDown()) do
		c.move.down({ destroy = true })
		height = height + 1
	end
	c.gps.goTo(basePos)

	-- Clear top of tree
	c.tree.chopRecursive(height, options)

	c.gps.goTo(basePos)
	c.move.back()

	return true
end)

m.harvestOnce = c.task.wrapLog("c.tree.harvestOnce", function()
	c.nTimes(4, function()
		c.tree.chop()
		if c.inventory.select(c.item.all.saplings) then
			local planted = turtle.place()
			if not planted and not turtle.detect() then
				c.report.warning("Currently no support for planting saplings without base dirt")
			end
		end
		c.turn.right()
	end)
end)

m.harvestTil = c.task.wrapLog("c.tree.harvestTil", function(til)
	c.gps.goHome()

	-- Run once, if no til provided
	local x = 0
	til = til or function()
		x = x + 1
		return x == 2
	end

	while not til() do
		c.tree.harvestOnce()

		if til() then
			break
		end

		c.report.info("Sleeping because til not reached")
		sleep(10)
	end
end)

return m

local m = {}

local digForward = function()
	if c.inspect.hasTag("minecraft:logs", turtle.inspect()) then
		return c.tree.chop()
	end
	return c.dig.forward()
end

m.collectOak = function(height)
	if height < 3 then
		c.report.warning("Not collecting oak leaves, tree too short")
		return false
	end

	c.move.up()

	c.report.info("Chop top 2 small leaf sections")
	c.range(2):forEach(function()
		c.range(4):forEach(function()
			c.turn.right()
			digForward()
		end)
		c.move.down()
	end)

	c.report.info("Top of larger leaf sections")
	c.move.forward()
	c.turn.right()

	c.report.info("Beginning of larger leaf section harvesting")
	c.range(4):forEach(function()
		digForward()
		c.move.forward()
		digForward()
		c.turn.left()
		digForward()
		c.move.down()
		digForward()
		c.turn.right()
		digForward()
		c.turn.right()
		digForward()
		c.move.forward()
		c.turn.left()
		digForward()
		c.move.up()
		digForward()
		c.turn.right()
	end)

	c.report.info("Moving to origin of harvest")
	c.turn.left()
	c.move.back()
	c.move.down({ times = height - 1 })

	return true
end

m.collect = c.task.wrapLog("c.leaf.collect", function(height)
	return c.leaf.collectOak(height)
end)

return m

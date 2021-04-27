local m = {}

m.collectOak = function(height)
	assert(height >= 3, "Somehow the trunk of this tree is not > 3 blocks tall: " .. height)

	c.move.up({ destroy = true })

	c.report.info("Chop top 2 small leaf sections")
	c.range(2):forEach(function()
		c.range(4):forEach(function()
			c.turn.right()
			c.dig.forward()
		end)
		c.move.down({ destroy = true })
	end)

	c.report.info("Top of larger leaf sections")
	c.move.forward({ destroy = true })
	c.turn.right()

	c.report.info("Beginning of larger leaf section harvesting")
	c.range(4):forEach(function()
		c.move.forward({ destroy = true })
		c.dig.forward()
		c.turn.left()
		c.dig.forward()
		c.move.down({ destroy = true })
		c.dig.forward()
		c.turn.right()
		c.dig.forward()
		c.turn.right()
		c.move.forward({ destroy = true })
		c.turn.left()
		c.dig.forward()
		c.move.up({ destroy = true })
		c.dig.forward()
		c.turn.right()
	end)

	c.report.info("Move to center after harvesting")
	c.turn.left()
	c.move.back({ destroy = true })
	c.move.down({ destroy = true, times = height - 1 })

	c.range(4):forEach(function()
		turtle.suck()
		c.turn.right()
	end)
	return true
end

m.collect = function(height)
	return c.leaf.collectOak(height)
end

return m

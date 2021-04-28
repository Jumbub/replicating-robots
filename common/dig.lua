local m = {}

m.withAssertions = function(dig)
	local success, error = dig()

	if error == "No tool to dig with" then
		c.task.reportTilTrue(function()
			return c.inventory.equip("minecraft:diamond_pickaxe")
		end, "Failed to equip pickaxe required for diging")

		success, error = dig()
	end

	return success, error
end

local recoverable = function(dig)
	return c.task.recoverable(function()
		return c.dig.withAssertions(dig)
	end)
end

m.forward = function()
	return recoverable(turtle.dig)
end

m.back = function()
	c.turn.around()
	local result = recoverable(turtle.dig)
	c.turn.around()
	return result
end

m.down = function()
	return recoverable(turtle.digDown)
end

m.up = function()
	return recoverable(turtle.digUp)
end

return m

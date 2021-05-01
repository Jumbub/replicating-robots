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
	return recoverable(turtle.native.dig)
end

m.back = function()
	c.turn.around()
	local result = m.forward()
	c.turn.around()
	return result
end

m.down = function()
	return recoverable(turtle.native.digDown)
end

m.up = function()
	return recoverable(turtle.native.digUp)
end

return m

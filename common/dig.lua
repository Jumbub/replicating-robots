local m = {}

local dig = function(dig)
	local success, error = dig()

	if error == "No tool to dig with" then
		c.task.wrapTryTilTrue("Attempting to equip pickaxe required for digging", function()
			return c.inventory.equip("minecraft:diamond_pickaxe")
		end)()

		success, error = dig()
	end

	return success, error
end

m.forward = function()
	return dig(turtle.native.dig)
end

m.back = function()
	c.turn.around()
	local result = m.forward()
	c.turn.around()
	return result
end

m.down = function()
	return dig(turtle.native.digDown)
end

m.up = function()
	return dig(turtle.native.digUp)
end

return m

local m = {}

m.dig = function(action)
	local success, error = action()

	if error == "No tool to dig with" then
		c.inventory.equip("minecraft:diamond_pickaxe")
		success, error = action()
	end
	if error == "Nothing to dig here" then
		success = true
		error = nil
	end

	return assert(success, "Failed to dig: " .. (error or ""))
end

local digRecoverable = function(action)
	c.task.recoverable(function()
		c.dig.dig(action)
	end, "Failed to dig")
end

m.forward = function()
	digRecoverable(turtle.dig)
	return true
end

m.back = function()
	c.turn.around()
	digRecoverable(turtle.dig)
	c.turn.around()
	return true
end

m.down = function()
	digRecoverable(turtle.digDown)
	return true
end

m.up = function()
	digRecoverable(turtle.digUp)
	return true
end

return m

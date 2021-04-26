local m = {}

m.direct = function(direction, options)
	options = options or {}
	options.destroy = options.destroy or false

	local success, error = turtle[direction]()

	if error == "Movement obstructed" and options.destroy and c.dig[direction]() then
		success, error = turtle[direction]()
	end
	if error == "Out of fuel" and c.fuel.refuel() then
		success, error = turtle[direction]()
	end

	return assert(success, "Failed to move: " .. (error or ""))
end

local moveRecoverable = function(direction, options)
	options = options or {}
	options.times = options.times and math.max(options.times, 0) or 1

	c.range(options.times):forEach(function()
		c.task.recoverable(function()
			c.move.direct(direction, options)
		end, "Inability to move " .. direction)
	end)
end

m.forward = function(options)
	moveRecoverable("forward", options)
	return true
end

m.back = function(options)
	moveRecoverable("back", options)
	return true
end

m.down = function(options)
	moveRecoverable("down", options)
	return true
end

m.up = function(options)
	moveRecoverable("up", options)
	return true
end

return m

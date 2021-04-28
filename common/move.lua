local m = {}

local withAssertions = function(direction, options)
	local destroy = options.destroy == nil or options.destroy

	local success, error = turtle[direction]()

	if success then
		return true
	end

	if error == "Movement obstructed" and destroy then
		while not success and c.dig[direction]() do
			success, error = turtle[direction]()
		end
	end

	if error == "Out of fuel" then
		c.fuel.refuel()
		success, error = turtle[direction]()
	end

	return success
end

local recoverable = function(direction, options)
	options = options or {}
	local times = options.times and math.max(options.times, 0) or 1

	local failedAt = c.range(times):findIndex(function()
		return not withAssertions(direction, options)
	end)
	if failedAt == -1 then
		failedAt = nil
	end

	return failedAt == nil, failedAt
end

m.forward = function(options)
	return recoverable("forward", options)
end

m.back = function(options)
	return recoverable("back", options)
end

m.down = function(options)
	return recoverable("down", options)
end

m.up = function(options)
	return recoverable("up", options)
end

return m

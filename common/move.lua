local m = {}

local move = function(direction)
	local success, error = turtle.native[direction]()
	if success then
		c.relativeGps[direction]()
	end
	return success, error
end

local withAssertions = function(direction, options)
	local destroy = options.destroy == nil or options.destroy

	local success, error = move(direction)

	if success then
		return true
	end

	if error == "Movement obstructed" and destroy then
		while not success and c.dig[direction]() do
			success, error = move(direction)
		end
	end

	if error == "Out of fuel" then
		c.fuel.refuel()
		success, error = move(direction)
	end

	return success
end

local INVERSE_DIR = {
	up = "down",
	down = "up",
	back = "forward",
	forward = "back",
}

local recoverable = function(direction, options)
	options = options or {}
	local times = options.times or 1

	if times < 0 then
		direction = INVERSE_DIR[direction]
	end

	local failedAt = c.range(math.abs(times)):findIndex(function()
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

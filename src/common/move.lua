local m = {}

local abortTilSufficientFuel = c.task.wrapLog("c.move.abortTilSufficientFuel", function()
  -- Avoid infinite loops
  local moveAbortions = c.state.get("moveAbortions", 0)
	if moveAbortions >= 5 then
    c.state.set("moveAbortions", 0)
		error("Attempted to abort, but the stack already has 5 abortions")
	end
  c.state.set("moveAbortions", moveAbortions + 1)

	local abortPos = c.gps.getCurrent()
	c.report.warning(
		"Attempted to move, but not a safe amount of fuel. Temporarily aborting task to harvest fuel.",
		abortPos
	)

  c.report.debug('Aborting movement', {
    abortions = moveAbortions,
    abortPos,
  })
	c.tree.harvestTil(function()
		if c.fuel.available() >= c.vector.distAtoB(c.gps.getCurrent(), abortPos) + 80 then
			c.report.info("Harvested enough wood to return to previous task.")
			return true
		end
		return false
	end)

	c.gps.goTo(abortPos)
  c.report.debug('Resumed previous position', {
    abortPos = abortPos,
    currentPos = c.gps.getCurrent(),
  })

  c.state.set("moveAbortions", moveAbortions)
end)

local move = function(direction)
	if not c.fuel.safeMove(direction) then
		-- Last ditch attempt, dig the block, maybe it's fuel (seems like a hack for the first tree :/)
		c.dig[direction]()
		if not c.fuel.safeMove(direction) then
			abortTilSufficientFuel()
		else
			c.fuel.refuel()
		end
	end
	local success, error = turtle.native[direction]()
	if success then
		c.gpsRelative[direction]()
	end
	return success, error
end

local withAssertions = function(direction, options)
	local success, error = move(direction)

	if success then
		return true
	end

	local destroy = options.destroy == nil or options.destroy
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
	local absTimes = math.abs(times)

	if times < 0 then
		direction = INVERSE_DIR[direction]
	end

	-- Determine if turning around will be faster then moving backwards
	local backSpecialCase = absTimes > 1 and direction == "back"
	if backSpecialCase then
		direction = "forward"
		c.turn.around()
	end

	local failedAt = c.range(absTimes):findIndex(function()
		return not withAssertions(direction, options)
	end)
	if failedAt == -1 then
		failedAt = nil
	end

	if backSpecialCase then
		c.turn.around()
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

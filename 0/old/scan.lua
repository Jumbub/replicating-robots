local m = {}

local goToScan = c.task.wrapLog("c.scan.goToScan", function()
	local state = c.state.get("scan", nil)
	if not state then
		-- Scan home block
		c.gps.goHome()

		-- Save state
		c.state.set("scan", {
			last = c.gps.getCurrent(),
			loops = 0,
			edges = 0,
		})
	else
		-- Resume
		c.gps.goTo(state.last)
	end
end)

local smartDig = function()
	if c.inspect.hasTag("minecraft:logs", c.inspect.forward()) then
		return c.tree.chop()
	elseif
		c.inspect.hasTag("minecraft:leaves", c.inspect.forward())
		or c.inspect.shouldDig("scan", c.inspect.forward())
	then
		return c.dig.forward()
	end
	return false
end

-- Returns the result of the final dig
local inspect = function()
	c.turn.right()
	while smartDig() do
	end
	c.turn.around()
	while smartDig() do
	end
	c.turn.right()
	return smartDig()
end

m.forward = function(times)
	if times <= 0 then
		return
	end

	-- Climb over blocks that we should not dig
	while not c.move.forward({ destroy = false }) do
		if not inspect() then
			c.move.up()
		end
	end

	inspect()

	-- Climb down to last block we shouldn't dig
	while
    not turtle.detectDown()
    or c.inspect.shouldDig("scan", c.inspect.down())
		or c.inspect.hasTag("minecraft:leaves", c.inspect.down())
  do
		c.move.down()
		inspect()
	end

	-- Recursion
	m.forward(times - 1)
end

local squigle = function()
	c.turn.right()
	m.forward(1)
	c.turn.left()
	m.forward(2)
end

m.next = c.task.wrapLog("c.scan.next", function()
	local state = c.state.get("scan", nil)
	if not state then
		goToScan()
		state = c.state.get("scan", nil)
		assert(state, "Scan state should be configured")
		assert(state.last, "Scan state should have a last")
	end

	-- Go to scanning location
	c.gps.goTo(state.last)

	local loops = math.floor(state.edges / 4)
	local edge = state.edges % 4
	c.report.info("Running scan loop " .. loops .. " on edge " .. edge)

	-- Scan
	if loops == 0 then
		c.gps.faceR(edge + 1)
		if edge == 3 then
			m.forward(2)
		else
			smartDig()
		end
	else
		c.nTimes(loops - 1, squigle)
		c.turn.right()
		local offset = (loops - 1) * 3
		if edge == 0 then
			m.forward(3 + offset)
		elseif edge == 1 then
			m.forward(4 + offset)
		elseif edge == 2 then
			m.forward(6 + offset)
		elseif edge == 3 then
			m.forward(5 + offset)
		end
	end

	-- Update state
	state.edges = state.edges + 1
	state.last = c.gps.getCurrent()
	c.state.set("scan", state)
end)

m.til = c.task.wrapLog("c.scan.til", function(til)
	while not til() do
		m.next()
	end
end)

return m

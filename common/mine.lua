local m = {}

local MAX_EDGES = 30

m.goToMine = function()
	local state = c.state.get("mine", nil)
	if not state then
		c.gps.goHome()
		while c.move.down() do
		end
		c.nTimes(4, c.move.up)
		state = {
			base = c.gps.getCurrent(),
			last = c.gps.getCurrent(),
			dist = 0,
			goalDist = 0,
			edgeNumber = 0,
			level = 0,
		}
		c.state.set("mine", state)
	else
		c.gps.goTo(state.base)
	end
end

m.check = function(direction)
	if c.inspect.shouldDig(c.inspect[direction]()) then
		c.dig[direction]()
	end
end

m.block = function()
	local state = c.state.get("mine", nil)
	if not state then
		m.goToMine()
		state = c.state.get("mine", nil)
		assert(state, "Mine state should be configured")
		assert(state.last, "Mine state should have a last")
	end
	c.gps.goTo(state.last)

	-- Check for mineables
	c.turn.right()
	m.check("down")
	m.check("forward")
	m.check("up")
	c.turn.around()
	m.check("forward")
	c.turn.right()

	-- Check if its time to turn
	assert(state.dist <= state.goalDist, "Somehow the mining algorithm has blown up")
	if state.dist == state.goalDist then
		m.check("forward")
		c.turn.right()

		-- Gaps of 3
		-- if state.edgeNumber % 2 == 0 then
		-- 	state.goalDist = state.goalDist + 3
		-- else
		-- 	state.goalDist = state.goalDist + 1
		-- end

		-- Gaps of 2
		if state.edgeNumber % 2 == 0 then
			state.goalDist = state.goalDist + 3
		end

		state.edgeNumber = state.edgeNumber + 1
		state.dist = 0 -- The value will be 0 when the future +1 is applied

		c.state.set("mine", state)
	end

	if state.edgeNumber >= MAX_EDGES then
		-- Move to next level
		state.level = state.level + 1
		state.dist = 0
		c.gps.goTo({ x = state.base.x, y = state.base.y + state.level, z = state.base.z, r = state.base.r })

		-- Move to next block
		c.move.forward()
		state.last = c.gps.getCurrent()
		c.state.set("mine", state)
	else
		-- Move to next block
		c.move.forward()
		state.last = c.gps.getCurrent()
		state.dist = state.dist + 1
		c.state.set("mine", state)
	end
end

m.til = function(til)
	while not til() do
		m.block()
	end
end

return m

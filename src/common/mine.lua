local m = {}

local MINING_TOP_HEIGHT = 14
local MINING_BOTTOM_HEIGHT = 4

local checkDir = function(direction)
	local success, block = c.inspect[direction]()
	if c.inspect.shouldDig("mine", success, block) then
		c.report.info("Found something worth mining: " .. block.name)
    c.report.info('Inventory info', {
      items = c.range(16):map(function(i) return turtle.getItemDetail(i) end)
    })
    c.inventory.moveToEarlySlots()
    if turtle.getItemCount() == 0 then
      turtle.select(1)
    end
		c.dig[direction]()
	end
end

local check = function()
  checkDir('forward')
end

local spin = function()
	c.forI(4, function(i)
		check()
		if i ~= 4 then
			c.turn.right()
		end
	end)
end

local squigle = function()
	c.move.forward()
  checkDir('up')
  checkDir('down')
	c.turn.left()
	check()
	c.turn.right()
	c.move.forward()
  checkDir('up')
  checkDir('down')
	check()
	c.turn.left()
	check()
	c.turn.around()
	c.move.forward()
  checkDir('up')
  checkDir('down')

	-- Relies on spin only turning 3 times
	check()
  c.turn.right()
	spin()
end

local goToMine = c.task.wrapLog("c.mine.goToMine", function()
	local state = c.state.get("mine", nil)
	if not state then
		c.gps.goHome()
		while c.move.down() do
      spin()
		end

		-- Move to origin
		c.nTimes(MINING_TOP_HEIGHT, c.move.up)

		-- Save state
		c.state.set("mine", {
			origin = c.gps.getCurrent(),
			last = c.gps.getCurrent(),
			minedPrev = false,
			goalCount = 1,
			turns = 0,
			count = 0,
		})
	else
		-- Resume
		c.gps.goTo(state.last)
	end
end)

local vertical = function(lastR, lastY)
	-- Mine to bottom
	while c.move.down() do
		spin()
	end

	-- Move out of bedrock zone
	c.nTimes(MINING_BOTTOM_HEIGHT, c.move.up)

	-- Re-orient, then squigle
	c.gps.faceR(lastR)
	squigle()

	-- Mine to top, then re-orient
	while c.gps.getCurrent().y < lastY do
		spin()
		c.move.up()
	end
	c.gps.faceR(lastR)
end

m.next = c.task.wrapLog("c.mine.next", function()
	local state = c.state.get("mine", nil)
	if not state then
		goToMine()
		state = c.state.get("mine", nil)
		assert(state, "Mine state should be configured")
		assert(state.last, "Mine state should have a last")
	end

	-- Go to mining location
	c.gps.goTo(state.last)

	-- Mine
	if state.minedPrev then
		squigle()
	else
		vertical(state.last.r, state.last.y)
	end

	-- Update stats
	state.minedPrev = not state.minedPrev
	state.count = state.count + 1

	-- Determine if we should turn
	assert(state.count <= state.goalCount, "Somehow we've skipped a mine iteration")
	if state.count == state.goalCount then
		c.turn.right()
		state.count = 0
		state.turns = state.turns + 1
		if state.turns % 2 == 0 then
			state.goalCount = state.goalCount + 1
		end
	end

	-- Update GPS after turning
	state.last = c.gps.getCurrent()

	-- Update state
	c.state.set("mine", state)
end)

m.til = c.task.wrapLog("c.mine.til", function(til)
	while not til() do
		m.next()
	end
end)

return m

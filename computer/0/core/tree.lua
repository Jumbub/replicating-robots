require("common")
local fuel = require("common.fuel")
local report = require("common.report")

local move = function(movement)
	if turtle.getFuelLevel() == 0 then
		while not fuel.refuel() do
			report.stuck("Stuck in a tree, no fuel")
		end
	end
	while not movement() do
		report.stuck("Stuck in a tree, movement failed")
	end
end

local hasTag = function(tag, success, block)
	if success then
		return block.tags[tag]
	end
	return false
end

local chopUp
chopUp = function()
	if not hasTag("minecraft:logs", turtle.inspectUp()) then
		return
	end

	assert(turtle.digUp(), "Somehow digging up has returned false")
	move(function()
		return turtle.up()
	end)

	chopUp()

	move(function()
		return turtle.down()
	end)
end

local chop = function()
	if not hasTag("minecraft:logs", turtle.inspect()) then
		return false
	end
	turtle.dig()

	move(function()
		return turtle.forward()
	end)

	chopUp()

	move(function()
		return turtle.back()
	end)
	return true
end

return {
	chop = chop,
}

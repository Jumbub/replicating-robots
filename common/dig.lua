local m = {}

local dig = function(options, dig)
	local success, error = dig()

	if error == "No tool to dig with" then
		c.task.wrapMustResolveTrue("Attempting to equip pickaxe required for digging", function()
			return c.inventory.equip("minecraft:diamond_pickaxe")
		end)()

		success, error = dig()
	end

	if success and options.ensureFreeSlot then
		-- Ensure slot to receive item
		c.inventory.ensureFreeSlot()
	end

	return success, error
end

local optional = function(options, nativeDig, nativeInspect)
	options = options or {}
	-- Just dig
	if not options.optional then
		return dig(options, nativeDig)
	end

	-- Optionally dig
	local success, block = nativeInspect()
	if not c.inspect.shouldDig(success, block) then
		return false
	end
	c.report.info("Digging " .. block.name)
	return dig(options, nativeDig)
end

local smart = function(options, nativeDig, nativeInspect)
	options = options or {}
	-- Just dig
	if not options.smart then
		return optional(options, nativeDig, nativeInspect)
	end

	-- Smart dig task
	local success, block = nativeInspect()
	if c.inspect.shouldChop(success, block) then
		c.report.info("Smart dig indicates this is a tree " .. block.name)
		return c.tree.chop()
	end
	return optional(options, nativeDig, nativeInspect)
end

m.forward = function(options)
	return smart(options, turtle.native.dig, turtle.inspect)
end

m.back = function()
	c.turn.around()
	local result = m.forward()
	c.turn.around()
	return result
end

m.down = function(options)
	return smart(options, turtle.native.digDown, turtle.inspectDown)
end

m.up = function(options)
	return smart(options, turtle.native.digUp, turtle.inspectUp)
end

return m

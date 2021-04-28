local m = {}

m.requireResource = function(success, block)
	if not success then
		return false
	end

	return c.goal.collectItem(block.name)
end

m.hasTag = function(tag, success, block)
	if success then
		return block.tags[tag]
	end
	return false
end
m.hasOneTag = function(tags, success, block)
	return Array(tags):some(function(tag)
		return c.inspect.hasTag(tag, success, block)
	end)
end
m.hasName = function(name, success, block)
	return success and string.find(block.name, name) and true or false
end

m.forward = function()
	return turtle.inspect()
end

m.back = function()
	c.turn.around()
	local data = turtle.inspect()
	c.turn.around()
	return data
end

m.down = function()
	return turtle.inspectDown()
end

m.up = function()
	return turtle.inspectUp()
end

return m

local m = {}

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

return m

local modify = require("src.world.modify")

local m = {}

m.clone = function(size)
	modify.forChunks(0, 0, size, size, modify.cloneInverseChunk(size))
end

m.fence = function(size)
	modify.forChunks(0, 0, size, size, modify.fenceChunk)

	m.clone(size)
end

m.debug = function(size)
	modify.forChunks(-size, 0, -1, size, modify.fillBaseWithDebug)
	modify.forChunks(0, -size, size, -1, modify.fillBaseWithDebug)

	m.fence(size)
end

m.rules = function(size)
	modify.run("gamerule", "doDaylightCycle", "false")
	modify.run("gamerule", "doWeatherCycle", "false")

	m.debug(size)
end

m.full = function(size)
	m.rules(size)
end

return m

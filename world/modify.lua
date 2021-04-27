require("common")
require("lib")

local m = {}

m.chunk_size = 16
m.base_y = 63
m.max_y = 100
m.debug_block = "minecraft:yellow_wool"
m.border_block = "minecraft:bedrock"
m.air_block = "minecraft:air"

m.join = function(array)
	return Array(array):join(" ")
end

m.run = function(...)
	local cmd = m.join({ ... })
	print("$ " .. cmd)
	local a, b, c = exec(cmd)
	print(textutils.serialiseJSON({ a, b, c }))
	print()
end

m.fill = function(start, stop, block, ...)
	m.run("fill", m.join(start), m.join(stop), block, ...)
end
m.clone = function(start, stop, to, block, ...)
	m.run("clone", m.join(start), m.join(stop), m.join(to), block, ...)
end

m.chunkStart = function(cx, cz)
	return { cx * m.chunk_size, 0, cz * m.chunk_size }
end
m.chunkStop = function(cx, cz)
	local x, _, z = table.unpack(m.chunkStart(cx + 1, cz + 1))
	return { x - 1, m.max_y, z - 1 }
end

m.forChunks = function(startX, startZ, stopX, stopZ, action)
	for x = startX, stopX do
		for z = startZ, stopZ do
			action(x, z)
		end
	end
end

m.fillBaseWithDebug = function(x, z)
	local start = m.chunkStart(x, z)
	local stop = m.chunkStop(x, z)
	start[2] = m.base_y
	stop[2] = m.base_y
	m.fill(start, stop, m.debug_block)
end

m.fenceChunk = function(x, z)
	local sx, sy, sz = table.unpack(m.chunkStart(x, z))
	local ex, ey, ez = table.unpack(m.chunkStop(x, z))
	m.fill({ sx - 1, sy, sz - 1 }, { ex + 1, ey, ez + 1 }, m.border_block, "outline")
	m.fill({ sx, ey, sz }, { ex, ey, ez }, m.air_block)
end

m.cloneInverseChunk = function(n)
	return function(x, z)
		local ix, iz = x - n - 1, z - n - 1
		m.clone(m.chunkStart(ix, iz), m.chunkStop(ix, iz), m.chunkStart(x, z))
	end
end

return m

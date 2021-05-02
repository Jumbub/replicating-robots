local m = {}

m.tag = os.time()

-- Utility function
m.range = function(n)
	local arr = Array({})
	for i = 1, n, 1 do
		arr:push(i)
	end
	assert(#arr == n)
	return arr
end

-- Reload common packages globally
m.reload = function()
	Array(fs.list("common"))
		:map(function(file)
			return String.replace(file, ".lua", "")
		end)
		:forEach(function(file)
			if package.loaded["common." .. file] then
				package.loaded["common." .. file] = nil
			end
		end)

	package.loaded["common"] = nil
	require("common")

	c.report.warning("Reloaded common packages [" .. c.tag .. "]")

	return true
end

m.noopTrue = function()
	return true
end

m.nTimes = function(n, task)
	assert(n >= 0, "nTimes called with number smaller than 0: " .. n)
	for _ = 1, n do
		task()
	end
end
m.forI = function(n, task)
	assert(n >= 0, "forI called with number smaller than 0: " .. n)
	for i = 1, n do
		task(i)
	end
end

m.mutativeConcat = function(t, ...)
	for _, v in pairs({ ... }) do
		for vk, vv in pairs(v) do
			t[vk] = vv
		end
	end
	return t
end

-- Creates a recursive pipe (to allow catching exceptions etc.)
m.createPipe = function(...)
	return Array({ ... }):reduce(function(acc, nextWrap)
		return function(...)
			return nextWrap(acc(...))
		end
	end, function(...)
		return ...
	end)
end

m.pipe = function(args, ...)
	assert(type(args) == "table", "The args parameter is unpacked when passed to the functions")
	return m.createPipe(...)(args)
end

return m

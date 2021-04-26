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

return m

local m = {}

-- The following functions create new functions, rather than starting execution

m.wrapLog = c.report.wrapLog

m.wrapTry = function(name, task)
	return function(...)
		local success, result = pcall(m.wrapLog(name, task), ...)
		while not success do
			c.report.error("Task failed: " .. name, { success = success, result = result })
			c.report.debug("Press any key after resolving issue...")
			read()
			c.reload()
			success, result = pcall(task)
		end
		return result
	end
end

m.wrapTryTilTrue = function(name, task)
	return function(...)
		local result = nil
		repeat
			result = m.wrapTry(name, task)(...)
		until result
		return result
	end
end

m.timeMs = c.createPipe(function(name, task)
	local start = os.epoch("utc")
	task()
	local ms = os.epoch("utc") - start
	if name then
		dd("Time taken for task: " .. name, "ms: " .. ms, "s: " .. ms / 1000)
	end
	return ms
end)

return m

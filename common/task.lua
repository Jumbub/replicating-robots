local m = {}

m.recoverable = function(task, errorMessage)
	errorMessage = errorMessage or "Failed"
	local success, result = pcall(task)
	while not success do
		c.report.error(errorMessage, { success, result })
		c.report.debug("Press any key after resolving issue...")
		read()
		c.reload()
		success, result = pcall(task)
	end
	return result
end

m.reportTilTrue = function(task, errorMessage)
	errorMessage = errorMessage or "Failed"
	local success, result = pcall(task)
	while not result do
		c.report.error("Assert: " .. errorMessage, { success = success, result = result })
		c.report.debug("Press any key after resolving issue...")
		read()
		c.reload()
		success, result = pcall(task)
	end
	return result
end

return m

local m = {}

m.recoverable = function(task, errorMessage)
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

return m

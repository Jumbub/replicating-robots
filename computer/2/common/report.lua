local m = {}

local format = function(data)
	if type(data) == "string" then
		return data
	elseif data == nil then
		return "nil"
	end
	return textutils.serialiseJSON(data)
end

local insertMessage = function(message, ...)
	local data = { ... }
	if type(data[1]) == "string" then
		data[1] = message .. ": " .. data[1]
	else
		data[1] = message .. ": " .. format(data[1])
	end
	return table.unpack(data)
end

local withSimpleTrace = function(...)
	local info = debug.getinfo(3, "S")
	local packageName = String.replace(info.short_src, ".lua", "")

	return insertMessage(packageName, ...)
end

m.report = function(color, ...)
	term.setTextColor(color)

	Array({ ... }):forEach(function(data)
		print(format(data))
	end)
	print("")
end

m.error = function(...)
	m.report(colors.red, debug.traceback(), "", withSimpleTrace(...))
end

m.warning = function(...)
	m.report(colors.orange, ...)
end

m.info = function(...)
	m.report(colors.yellow, ...)
end

m.debug = function(...)
	m.report(colors.lightGray, withSimpleTrace(...))
end

return m

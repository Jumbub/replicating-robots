local m = {}

local ID = os.getComputerID()
local STATE_DIR = "memory"
local STATE_FILE = STATE_DIR .. "/" .. ID .. ".log"

m.format = function(data)
	if type(data) == "string" then
		return data
	elseif data == nil then
		return "nil"
	end
	local success, result = pcall(textutils.serialiseJSON, data)
	if success then
		return result
	end
	return tostring(data)
end

local insertMessage = function(message, ...)
	local data = { ... }
	if type(data[1]) == "string" then
		data[1] = message .. ": " .. data[1]
	else
		data[1] = message .. ": " .. m.format(data[1])
	end
	return table.unpack(data)
end

local withSimpleTrace = function(...)
	local info = debug.getinfo(3, "S")
	local packageName = String.replace(info.short_src, ".lua", "")

	return insertMessage(packageName, ...)
end

local log = function(message, noOffset)
	if not noOffset then
		local offset = m.getMessageOffset()
		message = c.range(offset):fill(" "):join("") .. offset .. "| " .. message
	end

	print(message)

	local file = fs.open(STATE_FILE, "a")
	assert(file, "Somehow I cannot write to the state file")
	file.writeLine(message)
	file.close()
end

m.report = function(color, ...)
	term.setTextColor(color)

	Array({ ... }):forEach(function(data)
		log(m.format(data))
	end)
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

m.separator = function(message)
	log("\n\n" .. message .. "\n\n", true)
end

m.getMessageOffset = function()
	return #c.state.get("reportTaskList", {})
end

m.wrapLog = function(name, task)
	return function(...)
		local args = { ... }
		c.state.update("reportTaskList", {}, function(tasksRaw)
			local tasks = Array(tasksRaw)
			tasks:push(name)
			m.info("RUN " .. name .. " WITH " .. m.format(args))
			return tasks
		end)

		local result = { pcall(function()
			return task(unpack(args))
		end) }

		local errors = not result[1]

		local finishedTaskName = nil
		c.state.update("reportTaskList", {}, function(tasksRaw)
			local tasks = Array(tasksRaw)
			finishedTaskName = tasks:pop()
			return tasks
		end)

		if errors then
			m.warning("ABORT " .. result[2])
		else
			m.info("END " .. finishedTaskName)
		end

		if errors then
			if #c.state.get("reportTaskList", {}) > 0 then
				error(result[2])
			else
				c.report.error(result[2])
			end
		end

		table.remove(result, 1)
		return unpack(result)
	end
end

_G.dd = m.debug

return m

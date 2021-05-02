local m = {}

local ID = os.getComputerID()
local STATE_DIR = "memory"
local STATE_FILE = STATE_DIR .. "/" .. ID .. ".log"

local format = function(data)
	if type(data) == "string" then
		return data
	elseif data == nil then
		return "nil"
	elseif type(data) == "function" then
		return "<function>"
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
		log(format(data))
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
		c.state.updateKey("reportTaskList", {}, function(tasksRaw)
			local tasks = Array(tasksRaw)
			tasks:push(name)
			m.info("Starting task: " .. name)
			return tasks
		end)

		local result = task(...)

		local finishedTaskName = nil
		c.state.updateKey("reportTaskList", {}, function(tasksRaw)
			local tasks = Array(tasksRaw)
			finishedTaskName = tasks:pop()
			return tasks
		end)
		m.info("Finished task: " .. finishedTaskName)

		return result
	end
end

_G.dd = m.debug

return m

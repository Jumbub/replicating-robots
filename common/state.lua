local m = {}

local ID = os.getComputerID()
local STATE_DIR = "memory"
local STATE_FILE = STATE_DIR .. "/" .. ID .. ".json"

local write = function(state)
	local file = fs.open(STATE_FILE, "w")
	assert(file, "Somehow I cannot write to the state file")
	file.write(textutils.serialiseJSON(state))
	file.close()
end

local read = function()
	local file = fs.open(STATE_FILE, "r")
	assert(file, "Somehow I cannot read from the state file")
	local state = textutils.unserialiseJSON(file.readAll()) or {}
	file.close()

	return state
end

m.update = function(action)
	write(action(read()))
end

m.updateKey = function(key, default, action)
	m.update(function(state)
		local newValue = action(state and state[key] or default)
		state[key] = newValue
		return state
	end)
end

m.set = function(key, value)
	local state = read()
	state[key] = value
	write(state)
end

m.get = function(key, default)
	local state = read()
	return state[key] or default
end

m.reset = function()
	c.report.separator("State reset")
	write({})
end

return m

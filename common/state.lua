local m = {}

local ID = os.getComputerID()
local STATE_DIR = "memory"
local STATE_FILE = STATE_DIR .. "/" .. ID .. ".json"

local ensureFileExists = function()
	if not fs.exists(STATE_DIR) then
		fs.makeDir(STATE_DIR)
	end
	if not fs.exists(STATE_FILE) then
		local file = fs.open(STATE_FILE, "w")
		file.write(textutils.serialiseJSON({}))
		file.close()
	end
	assert(fs.isDir(STATE_DIR), "Somehow there exists a state file. Expecting a directory.")
end

local write = function(state)
	ensureFileExists()

	local file = fs.open(STATE_FILE, "w")
	file.write(textutils.serialiseJSON(state))
	file.close()
end

local read = function()
	ensureFileExists()

	local file = fs.open(STATE_FILE, "r")
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

m.get = function(key, default)
	local state = read()
	return state[key] or default
end

m.reset = function()
	write({})
end

return m

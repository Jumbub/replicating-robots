local m = {}

local write = function(state)
	local file = fs.open("state.json", "w")
	file.write(textutils.serialiseJSON(state))
	file.close()
end

local read = function()
	local file = fs.open("state.json", "r")
	local state = textutils.unserialiseJSON(file.readLine())
	file.close()
	return state
end

local update = function(action)
	local state = read()
	action(state)
	write(state)
end

m.setState = function(key, value)
	update(function(state)
		state[key] = value
	end)
end

m.getState = function(key, default)
	local state = read()
	return state[key] or default
end

m.incrementState = function(key)
	update(function(state)
		state[key] = (state[key] or 0) + 1
	end)
end

m.reset = function()
	write({})
end

return m

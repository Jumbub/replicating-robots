-- Copyright (c) 2018, xiedacon.

local utility = {
	_VERSION = "0.3",
	array = require("lib.lua-utility.lib.utility.array"),
	func = require("lib.lua-utility.lib.utility.function"),
	object = require("lib.lua-utility.lib.utility.object"),
	string = require("lib.lua-utility.lib.utility.string"),
}

function utility.try(fns, catch)
	if not catch or type(catch) ~= "function" then
		catch = function(err)
			return nil, err
		end
	end

	local res
	local err

	for _, fn in ipairs(fns) do
		res, err = fn(res)

		if err then
			return catch(err)
		end
	end

	return res
end

function utility.noop()
end

function utility.once(fn)
	local done = false

	return function(...)
		if done then
			return
		else
			done = true
			return utility.func.apply(fn, { ... })
		end
	end
end

return utility

require("lib")

_G.turtle = turtle
_G.colors = colors
_G.term = term

_G.dd = function(...)
	print(...)
end

Range = function(n)
	local arr = Array({})
	for i = 1, n, 1 do
		arr:push(i)
	end
	assert(#arr == n)
	return arr
end

PurgeCommon = function()
	package.loaded["common.chest"] = nil
	package.loaded["common.craft"] = nil
	package.loaded["common.fuel"] = nil
	package.loaded["common.inventory"] = nil
	package.loaded["common.move"] = nil
	package.loaded["common.report"] = nil
	package.loaded["common.report"] = nil
end

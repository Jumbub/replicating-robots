require("common")

local stuck = function(message)
	term.setTextColor(colors.red)
	print(message)
	term.setTextColor(colors.lightGray)
	print("Press any key after resolving issue...")
	term.setTextColor(colors.white)
	read()
end

local no = function(message)
	term.setTextColor(colors.yellow)
	print(message)
end

return { stuck = stuck, no = no }

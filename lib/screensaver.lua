local color = { colors.red, colors.orange, colors.yellow, colors.white, colors.lightGray, colors.gray }
local refresh = 0.05
local frequency = 10
local text = { "wait, did that actually work", colors.lime }
local background = colors.black
local rainbowColors = true
-- change any of the above values to alter the look of the fireworks
term.setBackgroundColor(colors.black)
term.clear()
local fw = {}
local x, y = term.getSize()
color = rainbowColors and {
	{ colors.red, colors.orange, colors.yellow, colors.white },
	{ colors.green, colors.lime, colors.yellow, colors.white },
	{ colors.blue, colors.cyan, colors.lightBlue, colors.white },
	{ colors.purple, colors.magenta, colors.pink, colors.white },
} or color
local len = rainbowColors and #color[1] or #color
if rainbowColors then
	for i, t in ipairs(color) do
		t[#t + 1] = background
	end
else
	color[#color + 1] = background
end
local advance = function()
	for k, t in pairs(fw) do
		t[2] = t[3] == 1 and (t[2] + 0.5) or (t[2] - 1)
		t = t[3] == 1 and (t[2] <= (y + len) and t or nil) or (t[2] >= 1 - len and t or nil)
	end
end
local render = function()
	for k, t in pairs(fw) do
		for i = 1, len + 1 do
			if t[2] - i >= 1 then
				term.setCursorPos(t[1], math.floor(t[2]) - i)
				term.setTextColor(
					t[3] == 1 and (rainbowColors and color[t[4]][i] or color[i])
						or (rainbowColors and color[t[4]][len + 2 - i] or color[i])
				)
				term.write(t[3] == 1 and (t[2] % 1 == 0 and "-" or "_") or string.char(166))
			end
		end
	end
	term.setCursorPos((x - #text[1]) / 2, y / 2)
	term.setTextColor(text[2])
	for char in text[1]:gmatch(".") do
		if char ~= " " then
			term.write(char)
		else
			local xpos, ypos = term.getCursorPos()
			term.setCursorPos(xpos + 1, ypos)
		end
	end
end
local timer = os.startTimer(refresh)
while true do
	do
		local e = { os.pullEvent("timer") }
		if e[2] ~= timer then
			return
		end
		advance()
		if math.random(len / refresh / frequency) == 1 then
			local rand = math.random(2)
			fw[{}] = {
				math.random(x),
				rand == 1 and 0.5 or y + 1,
				rand,
				rainbowColors and math.random(#color) or nil,
			}
		end
		render()
		timer = os.startTimer(refresh)
	end
end

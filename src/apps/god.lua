require("lib")
require("src.common")

local commands = require("src.world.commands")

print("Playing god.\n")

rednet.open("top")
rednet.host("world", "god")

while true do
	local _, raw = rednet.receive("world")
	c.report.info("received:", raw)
	local msg = textutils.unserialiseJSON(raw)
	local success, error = pcall(commands[msg.mode or "clone"], msg.size or 2)
	if not success then
		c.report.error(error)
	end
end

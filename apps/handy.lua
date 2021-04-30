require("lib")

print("Talking to god.\n")

rednet.open("back")

while true do
	io.write("$ ")
	local input = read()
	local mode, size = table.unpack(String.split(input, " "))
	if mode == "" then
		mode = nil
	end
	if size == "" then
		size = nil
	end
	rednet.broadcast(textutils.serialiseJSON({ size = size, mode = mode }), "world")
end

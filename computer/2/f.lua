while turtle.down() do
end

local x = turtle.getFuelLevel()

for _ = 1, math.ceil(x / 2), 1 do
	turtle.digUp()
	turtle.up()
end
for _ = 1, math.ceil(x / 2), 1 do
	turtle.digDown()
	turtle.down()
end

print("remaining fuel:" .. turtle.getFuelLevel())

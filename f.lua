require("common")

while c.move.down({ destroy = false }) do
end

local x = turtle.getFuelLevel()

for _ = 1, math.ceil(x / 2), 1 do
	c.move.up()
end
for _ = 1, math.ceil(x / 2), 1 do
	c.move.down({ destroy = false })
end

print("remaining fuel:" .. turtle.getFuelLevel())

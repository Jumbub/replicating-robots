local m = {}

local FIRST_GOAL = "resources"

local ALWAYS_COLLECT = Array({
	"minecraft:diamond_ore",
	"minecraft:iron_ore",
	"minecraft:coal_ore",
	"minecraft:redstone_ore",
})

local GOALS = {
	[FIRST_GOAL] = Array({
		["minecraft:stone"] = 22,
		["minecraft:sand"] = 6,
		["*plank"] = 17,
	}),
}

m.collectItem = function(name)
	if ALWAYS_COLLECT:includes(name) then
		return true
	end

	local currentGoalName = c.state.getState("currentGoal", FIRST_GOAL)
	local currentGoal = GOALS[currentGoalName]

	local goalKey, goalValue = "", 0

	for key, value in pairs(currentGoal) do
		if String.startsWith(key, "*") then
			local looseKey = String.replace(key, "*", "")
			if string.find(name, looseKey) then
				goalValue = value
				goalKey = key
				break
			end
		else
			if key == name then
				goalValue = value
				goalKey = key
				break
			end
		end
	end

	if goalValue == 0 then
		return false
	end

	-- VERY poor item count code
	local hasItem = c.inventory.select(String.replace(goalKey, "*", ""))
	local count = hasItem and turtle.getItemCount() or 0

	return count < goalValue
end

return m

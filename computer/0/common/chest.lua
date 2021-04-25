require("common")
local inventory = require("common.inventory")
local report = require("common.report")

local placeChest = function()
	if not inventory.select("minecraft:chest") then
		report.no("No chest in inventory for stashing")
		return false
	end
	if not turtle.placeUp() then
		report.no("No success placing stash chest")
		return false
	end
	return true
end

local pickUpStash = function()
	Range(16):forEach(function()
		return turtle.suckUp()
	end)

	local _, reason = turtle.suckUp()
	while reason == "No space for items" do
		report.stuck("Expected to be able to pick up all items in stash, please clean out chest")
		reason = turtle.suckUp()
	end
	while not inventory.selectEmpty() do
		report.stuck("Expected to be able to pick up chest, but inventory is full, please remove an item from my inventory")
	end

	assert(turtle.digUp(), "Somehow digging up to retrieve the stash chest has returned false")

	return true
end

local stashExceptSingle = function(name, task)
	if not placeChest() then
		report.no("No ability to place chest for stashing")
		return false
	end
	local excepted = false
	Range(16)
		:map(function(i)
			return inventory.itemNameContains(i, name)
		end)
		:forEach(function(except, i)
			if not excepted and except then
				excepted = true
				return
			end
			turtle.select(i)
			turtle.dropUp()
		end)

	local result = task()
	if not result then
		report.no("No success executing task while stashed")
	end

	if not pickUpStash() then
		report.no("No ability to pick up the stash chest")
		return false
	end

	return true, result
end

return {
	stashExceptSingle = stashExceptSingle,
}

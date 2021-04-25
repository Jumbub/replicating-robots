require("common")
local inventory = require("common.inventory")
local chest = require("common.chest")
local report = require("common.report")

local single = function(name, preUnstash)
	if not inventory.equip("minecraft:crafting_table") then
		report.no("No crafting table equipable")
		return false
	end
	local stash, task = chest.stashExceptSingle(name, function()
		if not inventory.selectEmpty() then
			report.no("No success finding an empty slot to put the crafted item")
			return false
		end
		if not turtle.craft() then
			local meta = Range(16)
				:map(function(i)
					return inventory.itemName(i)
				end)
				:toString()
			report.no("No success while crafting '" .. name .. "'\n" .. meta)
			return false
		end
		if preUnstash then
			if not preUnstash() then
				report.no("No success doing pre unstash crafting task")
				return false
			end
		end
		return true
	end)
	if not stash then
		report.no("No success while stashing to perform craft")
		return false
	end
	if not task then
		report.no("No success while attempting to craft item")
		return false
	end
	return true
end

return {
	single = single,
}

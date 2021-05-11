local m = {}

-- Higher index is more important
m.ITEM_PRIORITIES = Array.concat(
	{
		-- Essential
		c.item.diamond_pickaxe,
		c.item.crafting_table,
		c.item.chest,
	},
	-- Fuel
	{ c.item.coal_block },
	c.item.all.coals,
	c.item.all.combustibleLogs,
	{
		-- Goal items
		c.item.turtle_normal,
		c.item.computer_normal,
	},
	{
		-- Goal resources
		c.item.diamond_ore,
		c.item.diamond,
		c.item.glass,
		c.item.glass_pane,
		c.item.sand,
		c.item.redstone,
		c.item.redstone_ore,
		c.item.iron_ingot,
		c.item.iron_ore,
		c.item.stone,
	},
	-- Easy to collect again
	c.item.all.combustiblePlanks,
	{
		c.item.stick,
		c.item.cobblestone,
	},
	-- Trash with some utility
	{
		c.item.dirt,
	}
):reverse()

m.GOALS = {
	tree = {
		{ items = { c.item.all.saplings }, count = 3 }, -- Used to prevent harvesting of leaves when redundant
	},
	scan = {
		{ items = { c.item.sand }, count = 6 },
		{ items = { c.item.all.combustibleLogs }, count = 12 },
		{ items = { c.item.all.leaves }, count = 1 }, -- Used to prevent climbing over trees
	},
	mine = {
		{ items = { c.item.coal }, count = 6 },
		{ items = { c.item.diamond }, count = 6 },
		{ items = { c.item.redstone }, count = 2 },
		{ items = { c.item.iron_ore }, count = 14 },
		{ items = { c.item.cobblestone }, count = 14 + 8 * 3 },
	},
}

m.leastImportantSlot = function()
	local details = Object.entries(c.inventory.items())
		:reduce(function(acc, detail)
			local _, details = unpack(detail)

			local importance = m.ITEM_PRIORITIES:findIndex(function(item)
				return item == detail[1]
			end)

			local slots = Array(details.slots):map(function(slot)
				return { slot = slot.slot, importance = importance, count = slot.count }
			end)

			return Array.concat(acc, slots)
		end, {})
		:sort(function(a, b)
			if a.importance == b.importance then
				return a.count < b.count
			end
			return a.importance < b.importance
		end)
	local detail = details[1]

	if detail then
		return detail.slot, detail
	else
		return nil
	end
end

m.shouldCollect = function(goal, name)
	local requirement = Array(m.GOALS[goal]):find(function(detail)
		return Array(detail.items):some(function(detailName)
			return detailName == name
		end)
	end)
	if not requirement then
		return false
	end
	return c.inventory.count(name) < requirement.count
end

m.achieved = function(goal)
	return Array(goal):every(function(goalDetail)
		return Array(goalDetail.items):some(function(goalItem)
			return c.inventory.count(goalItem) >= goalDetail.count
		end)
	end)
end

return m
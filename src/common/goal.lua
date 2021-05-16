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
		c.item.diamond,
		c.item.glass,
		c.item.glass_pane,
		c.item.sand,
		c.item.redstone,
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
		{ items = c.item.all.saplings, count = 3, limit = 64 }, -- Used to avoid wasting fuel collecting unecessary amounts of leaves
	},
	scan = {
		{ items = { c.item.sand }, count = 6, limit = 64 },
		{ items = c.item.all.combustibleLogs, count = 12, limit = 64 },
	},
	mine = {
		{ items = { c.item.coal }, blocks = { c.item.coal_ore }, count = 6, limit = 64 },
		{ items = { c.item.diamond }, blocks = { c.item.diamond_ore }, count = 6, limit = 64 },
		{ items = { c.item.redstone }, blocks = { c.item.redstone_ore }, count = 2, limit = 64 },
		{ items = { c.item.iron_ingot } , blocks = { c.item.iron_ore }, count = 14, limit = 64 },
		{ items = { c.item.cobblestone }, blocks = { c.item.stone }, count = 14 + 8 * 3, limit = 64 },
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
		end) or Array(detail.blocks):some(function(blockName)
			return blockName == name
		end)
	end)
	if not requirement then
		return false
	end
	return requirement.items:reduce(function(acc, item)
    return acc + c.inventory.count(item)
  end, 0) < requirement.limit
end

m.achieved = function(goal)
	return Array(goal):every(function(goalDetail)
		return Array(goalDetail.items):some(function(goalItem)
			return c.inventory.count(goalItem) >= goalDetail.count
		end)
	end)
end

return m

local m = {}

m.SHOULD_COLLECT = Array.concat(
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
	-- Helpful
	c.item.all.combustiblePlanks
)

-- Higher index is more important
m.ITEM_PRIORITIES = Array.concat(
	m.SHOULD_COLLECT,
	-- Helpful but easy to collect
	{
		c.item.stick,
		c.item.cobblestone,
	},
	-- Trash with some utility
	{
		c.item.dirt,
	}
):reverse()

m.SCAN_GOAL = Array({
	{ items = { c.item.sand }, count = 6 },
	{ items = c.item.all.combustibleLogs, count = 12 * 2 },
})
m.MINE_GOAL = Array({
	{ items = { c.item.diamond }, count = 6 },
	{ items = { c.item.redstone }, count = 2 },
	{ items = { c.item.iron_ore }, count = 14 },
	{ items = { c.item.cobblestone }, count = 14 + 8 * 3 },
})

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

m.shouldCollect = function(name)
	return m.SHOULD_COLLECT:some(function(item)
		return item == name
	end)
end

m.achieved = function(goal)
	local currentItems = c.inventory.items()
	return goal:every(function(goalDetail)
		return Array(goalDetail.items):some(function(goalItem)
			return currentItems[goalItem] and currentItems[goalItem].total >= goalDetail.count
		end)
	end)
end

return m

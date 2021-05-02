local m = {}

local getAlwaysDig = function()
	return Array({
		c.item.diamond_ore,
		c.item.redstone_ore,
		c.item.gold_ore,
		c.item.iron_ore,
		c.item.coal_ore,
	})
end

local sometimes = function(group, count)
	local g = {}
	Array(group):forEach(function(item)
		g[item] = { count = count, items = group }
	end)
	return g
end

local getSometimesDig = function()
	return c.mutativeConcat(
		sometimes(c.item.all.cobbled, 14 + c.smelt.requiredFurnaces() * 10),
		sometimes(c.item.all.sands, 64)
	)
end

m.shouldCollect = function(name)
	if getAlwaysDig():includes(name) then
		return true
	end

	local goal = getSometimesDig()[name]

	if not goal then
		return false
	end

	return c.inventory.count(goal.items) < goal.count
end

return m

local m = {}

local ALWAYS_DIG = Array({
	c.item.diamond_ore,
	c.item.redstone_ore,
	c.item.gold_ore,
	c.item.iron_ore,
	c.item.coal_ore,
})

local sometimes = function(group, count)
	local g = {}
	Array(group):forEach(function(item)
		g[item] = { count = count, items = group }
	end)
	return g
end

local SOMETIMES_DIG = c.mutativeConcat(sometimes(c.item.all.cobbled, 14), sometimes(c.item.all.sand, 6))

m.shouldCollect = function(name)
	if ALWAYS_DIG:includes(name) then
		return true
	end

	local goal = SOMETIMES_DIG[name]

	if not goal then
		return false
	end

	return c.inventory.count(goal.items) < goal.count
end

return m

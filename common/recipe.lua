return {
	-- Items
	[c.item.glass_pane] = { { names = c.item.all.sands, slots = { 1, 2, 3, 4, 5, 6 } } },
	[c.item.furnace] = {
		{ name = c.item.cobblestone, slots = { 1, 2, 3, 4, 6, 7, 8, 9 } },
	},
	[c.item.chest] = {
		{ names = c.item.all.combustiblePlanks, slots = { 1, 2, 3, 4, 6, 7, 8, 9 } },
	},
	[c.item.computer_normal] = {
		{ name = c.item.stone, slots = { 1, 2, 3, 4, 6, 7, 9 } },
		{ name = c.item.redstone, slots = { 5 } },
		{ name = c.item.glass_pane, slots = { 8 } },
	},
	[c.item.turtle_normal] = {
		{ name = c.item.iron, slots = { 1, 2, 3, 4, 6, 7, 9 } },
		{ name = c.item.computer, slots = { 5 } },
		{ name = c.item.chest, slots = { 8 } },
	},

	-- Item groups
	plank = {
		names = c.item.all.combustibleLogs,
		slots = { 1 },
	},
}

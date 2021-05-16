require("lib")

return Object.assign(
	{
		[c.item.diamond_pickaxe] = {
			{ { name = c.item.diamond, slots = { 1, 2, 3 } }, { name = c.item.stick, slots = { 5, 8 } } },
			1,
		},
		[c.item.glass_pane] = { { { name = c.item.glass, slots = { 1, 2, 3, 4, 5, 6 } } }, 16 },
		[c.item.crafting_table] = { { { names = c.item.all.combustiblePlanks, slots = { 1, 2, 4, 5 } } }, 1 },
		[c.item.sign] = {
			{
				{ names = c.item.all.combustiblePlanks, slots = { 1, 2, 3, 4, 5, 6 } },
				{ name = c.item.stick, slots = { 8 } },
			},
			3,
		},
		[c.item.stick] = { { { names = c.item.all.combustiblePlanks, slots = { 1, 4 } } }, 4 },
		[c.item.furnace] = {
			{
				{ name = c.item.cobblestone, slots = { 1, 2, 3, 4, 6, 7, 8, 9 } },
			},
			1,
		},
		[c.item.chest] = {
			{
				{ names = c.item.all.combustiblePlanks, slots = { 1, 2, 3, 4, 6, 7, 8, 9 } },
			},
			1,
		},
		[c.item.computer_normal] = {
			{
				{ name = c.item.stone, slots = { 1, 2, 3, 4, 6, 7, 9 } },
				{ name = c.item.redstone, slots = { 5 } },
				{ name = c.item.glass_pane, slots = { 8 } },
			},
			1,
		},
		[c.item.turtle_normal] = {
			{
				{ name = c.item.iron_ingot, slots = { 1, 2, 3, 4, 6, 7, 9 } },
				{ name = c.item.computer_normal, slots = { 5 } },
				{ name = c.item.chest, slots = { 8 } },
			},
			1,
		},
	},
	Object.fromEntries(Array(c.item.all.combustiblePlanks):map(function(plank)
		return {
			plank,
			{
        { {
          names = c.item.plankToLogs(plank),
          slots = { 1 },
        } },
				4,
			},
		}
	end)),

	-- Recipes not tied to items
	{
		plank = {
			{ { names = c.item.all.combustibleLogs, slots = { 1 } } },
			4,
		},
		crafty_miney_turtle_normal = {
			{
				{ name = c.item.diamond_pickaxe, slots = { 4 } },
				{ name = c.item.turtle_normal, slots = { 5 } },
				{ name = c.item.crafting_table, slots = { 6 } },
			},
			1,
		},
	}
)

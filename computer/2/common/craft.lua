local m = {}

m.single = function(name, preUnstash, quantity)
	if not c.inventory.equip("minecraft:crafting_table") then
		c.report.info("No crafting table equipable")
		return false
	end
	local stash, task = c.chest.stashExceptSingle(name, function()
		if not c.inventory.selectEmpty() then
			c.report.info("No success finding an empty slot to put the crafted item")
			return false
		end
		if not turtle.craft(quantity or 1) then
			c.report.info("No success while crafting", {
				name = name,
				inv = c.range(16):map(function(i)
					return c.inventory.itemName(i)
				end),
			})
			return false
		end
		if preUnstash then
			if not preUnstash() then
				c.report.info("No success doing pre unstash crafting task")
				return false
			end
		end
		return true
	end)
	if not stash then
		c.report.info("No success while stashing to perform craft")
		return false
	end
	if not task then
		c.report.info("No success while attempting to craft item")
		return false
	end
	return true
end

return m

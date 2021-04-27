local m = {}

local craftSingle = function(name, preCraft, preUnstash, quantity)
	quantity = quantity or 1
	preUnstash = preUnstash or c.noopTrue
	if not c.inventory.equip("minecraft:crafting_table") then
		c.report.info("No crafting table equipable")
		return false
	end
	local stash, task = c.chest.stashExceptSingle(name, function()
		if not c.inventory.selectEmpty() then
			c.report.info("No success finding an empty slot to put the crafted item")
			return false
		end
		if not preCraft() then
			c.report.info("No success in pre craft task")
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

m.single = function(name, preUnstash, quantity)
	return craftSingle(name, c.noopTrue, preUnstash, quantity)
end

m.donut = function(name, preUnstash, quantity)
	return craftSingle(name, function()
		if not c.inventory.selectNonEmpty() then
			c.report.info("Cannot select non empty slot")
			return false
		end
		return Array({ 1, 2, 3, 5, 7, 9, 10, 11 }):every(function(slot)
			if not turtle.transferTo(slot, 1) then
				c.report.info(
					"Somehow while crafting I cannot transfer from " .. turtle.getSelectedSlot() .. " to " .. slot
				)
				return false
			end
			return true
		end)
	end, preUnstash, quantity)
end

return m

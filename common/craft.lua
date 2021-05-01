local m = {}

local craftOneIngredient = function(name, quantity, preCraft, postCraft)
	quantity = quantity or 1
	postCraft = postCraft or c.noopTrue
	if not c.inventory.equip(c.item.crafting_table) then
		c.report.info("No crafting table equipable")
		return false
	end
	local stash, task = c.chest.stashExceptSingle(name, function()
		if not c.inventory.selectEmpty() then
			c.report.info("No success finding an empty slot to put the crafted item")
			return false
		end
		if not preCraft() then
			c.report.info("Pre-craft task failed")
			return false
		end
		c.inventory.selectEmpty()
		if not turtle.craft(quantity or 1) then
			c.report.info("No success while crafting", {
				name = name,
				inv = c.range(16):map(function(i)
					return c.inventory.itemName(i)
				end),
			})
			return false
		end
		if postCraft then
			if postCraft() == false then
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

local makeDonutShape = function(name)
	if not c.inventory.selectNonEmpty() then
		c.report.info("Cannot find ingredient: " .. name)
		return false
	end
	turtle.transferTo(1)
	turtle.select(1)
	return Array({ 2, 3, 5, 7, 9, 10, 11 }):every(function(slot)
		return turtle.transferTo(slot, 1)
	end)
end

m.single = function(name, quantity, preUnstash)
	return c.task.recoverable(function()
		return craftOneIngredient(name, quantity, c.noopTrue, preUnstash)
	end, "Failed to craft 'single'")
end

m.donut = function(name, quantity, preUnstash)
	return c.task.recoverable(function()
		return craftOneIngredient(name, quantity, makeDonutShape, preUnstash)
	end, "Failed to craft 'donut'")
end

m.capable = function()
	return (turtle.craft or c.inventory.has(c.item.crafting_table)) and true or false
end

return m

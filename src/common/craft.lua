local m = {}

m.capable = function()
	if turtle.craft then
		return true
	end
	return c.inventory.equip(c.item.crafting_table)
end

m.slotForPosition = function(i)
	local adder = math.ceil(i / 3)
	return i + adder + 4
end

-- @param recipe { name = string, names = array, slots = (1-9)[] }[]
-- @param quantity The minimum items produced
m.recipe = c.task.wrapLog("c.craft.recipe", function(recipe, quantity)
	quantity = quantity or 1
	if quantity == 0 then
		c.report.info("Nothing to craft")
		return true
	end
	assert(quantity >= 0)
	local ingredients, outputPerCraft = unpack(recipe)
	assert(ingredients, outputPerCraft)
	assert(m.capable(), "Expect turtles to be crafty enabled")

	-- Update ingredients to include single largest count item
	ingredients = Array(ingredients):map(function(ingredient)
		if ingredient.names then
			ingredient.name = c.inventory.largestCount(ingredient.names)
			ingredient.names = nil
		end
		return ingredient
	end)

	local crafts = math.ceil(quantity / outputPerCraft)

	-- Sanity check the ingredient list
	if
		Array(ingredients):some(function(item)
			return #item.slots * crafts > c.inventory.count(item.name)
		end)
	then
		c.report.warning("Not enough items to split into their crafting slots")
		return false
	end

	-- Stash unecessary items
	return c.stash.whitelist(
		Array(ingredients):map(function(ingredient)
			return { name = ingredient.name, count = crafts * #ingredient.slots }
		end),

		-- Craft function while stashed
		function()
			-- Position items
			c.inventory.moveToEarlySlots()
			Array(ingredients)
				:map(function(item)
					local splits = #item.slots
					local count = c.inventory.count(item.name)
					local slots = Array(item.slots):map(function(slot, i)
						local baseSplit = math.floor(count / splits)
						if i == 1 then
							return { slot, baseSplit + count % splits }
						else
							return { slot, baseSplit }
						end
					end)
					return { name = item.name, slots = slots }
				end)
				:forEach(function(item)
					c.inventory.select(item.name)
					Array(item.slots):forEach(function(detail)
						local slot, count = unpack(detail)
						turtle.transferTo(m.slotForPosition(slot), count)
					end)
				end)

			-- We have to craft into the 16th inventory slot to ensure we can do crafty miney turtles.
			-- Because we have no way of differentiating them using `getItemDetail`.
			turtle.select(16)
			return turtle.craft(crafts)
		end
	)
end)

return m

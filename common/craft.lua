local m = {}

m.capable = function()
	if turtle.craft or c.inventory.has(c.item.crafting_table) then
		return true
	end
	return false
end

m.slotForPosition = function(i)
	local adder = math.ceil(i / 3)
	return i + adder + 4
end

-- @param recipe { name = string, names = array, slots = (1-9)[] }[]
m.recipe = c.task.wrapLog("c.craft.recipe", function(recipe, quantity)
	quantity = quantity or 1
	assert(m.capable(), "Expect turtles to be crafty enabled")
	assert(quantity >= 0)
	assert(recipe)

	-- Update recipe to include single largest count item
	recipe = Array(recipe):map(function(ingredient)
		if ingredient.names then
			ingredient.name = c.inventory.largestCount(ingredient.names)
			ingredient.names = nil
		end
		return ingredient
	end)

	-- Sanity check the ingredient list
	if Array(recipe):some(function(item)
		return #item.slots * quantity > c.inventory.count(item.name)
	end) then
		c.report.warning("Not enough items to split into their crafting slots")
		return false
	end

	-- Stash unecessary items
	c.stash.whitelist(
		Array(recipe):map(function(ingredient)
			return { name = ingredient.name, count = quantity * #ingredient.slots }
		end),

		-- Craft function while stashed
		function()
			-- Position items
			c.inventory.moveToEarlySlots()
			Array(recipe)
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

			return turtle.craft(quantity)
		end
	)
end)

return m

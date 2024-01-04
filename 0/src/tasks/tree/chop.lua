local move = require("src.actions.move")
local craft = require("src.actions.craft")
local fuel = require("src.actions.fuel")
local rotate = require("src.actions.rotate")
local dig = require("src.actions.dig")
local inspect = require("src.actions.inspect")
local inventory = require("src.actions.inventory")

--- @param c TaskContext
return function(c)
  assert(dig.forward(), { complete = "Nothing to chop" })
  -- assert(inventory.findThenSelect({ tags = { "minecraft:oak_log" } }), "Inventory is full")
  -- assert(craft.many())
  -- assert(fuel.consume(1))
  assert(fuel.ensure(move.forward))
  assert(gps.track(fuel.ensure(move.forward)))
  -- while inspect.is("minecraft:oak_log", inspect.up()) do
  --   assert(dig.up())
  --   assert(move.up())
  -- end
  -- assert(move.down())

  -- -- leaves
  -- dig.forward()
  -- assert(move.forward())
  -- for _ = 1, 4 do
  --   dig.allDirections()
  --   assert(rotate.left())
  --   dig.allDirections()
  --   assert(move.forward())
  --   dig.allDirections()
  --   assert(rotate.right())
  --   dig.allDirections()
  --   assert(rotate.right())
  --   assert(rotate.right())
  --   dig.allDirections()
  --   assert(move.forward())
  --   assert(rotate.right())
  -- end
  -- assert(move.back())
  -- while not inspect.down() do
  --   assert(move.down())
  -- end
end

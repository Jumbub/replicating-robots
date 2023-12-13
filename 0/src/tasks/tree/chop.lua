local move = require("src.actions.move")
local craft = require("src.actions.craft")
local fuel = require("src.actions.fuel")
local rotate = require("src.actions.rotate")
local dig = require("src.actions.dig")
local inspect = require("src.actions.inspect")
local inventory = require("src.actions.inventory")

--- @param c TaskContext
return function(c)
  assert(inspect.is("minecraft:oak_log", inspect.forward()))
  assert(dig.forward())
  assert(inventory.find("minecraft:oak_log"))
  assert(craft.many())
  assert(fuel.consume(1))
  assert(move.forward())
  while inspect.is("minecraft:oak_log", inspect.up()) do
    assert(dig.up())
    assert(move.up())
  end
  assert(move.down())

  -- leaves
  dig.forward()
  assert(move.forward())
  for _ = 1, 4 do
    dig.all()
    assert(rotate.left())
    dig.all()
    assert(move.forward())
    dig.all()
    assert(rotate.right())
    dig.all()
    assert(rotate.right())
    assert(rotate.right())
    dig.all()
    assert(move.forward())
    assert(rotate.right())
  end
  assert(move.back())
  while not inspect.down() do
    assert(move.down())
  end
end

local rotate = {}

function rotate.left()
  return turtle.turnLeft()
end

function rotate.right()
  return turtle.turnRight()
end

-- --- @param count number
-- function rotate.many(count)
--   for _ = 1, math.abs(count) do
--     (count < 0 and turtle.turnLeft or turtle.turnRight)()
--   end
-- end

return rotate

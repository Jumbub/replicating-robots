local t = {}

function t.run(args, world)
  assert(world.gps, "Unsupported state for action")

  local success = turtle[args.direction]()

  if success then
    world.fuelLevel = world.fuelLevel - 1
  end

  return { world = world }
end

return t

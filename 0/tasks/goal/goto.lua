local t = {}

function t.idempotent(args, world)
  assert(world.position, "Unsupported state for action")

  local success = turtle[args.direction]()

  if success then
    world.fuelLevel = world.fuelLevel - 1
  end

  return { world = world }
end

return t

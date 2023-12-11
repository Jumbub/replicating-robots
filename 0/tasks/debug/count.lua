local task = {}

function task:complete(world)
  if not world.count then
    return false
  end

  local from = world.count or self.args.from

  local newState = Object.assign(world)

  local push = {}
  for _ = from, self.args.to do
    table.insert(push, { name = "debug.increment" })
  end

  return { complete = world.count == self.args.to, push = push }
end

function task:perform(world)
  dd(world.count)
end

return task

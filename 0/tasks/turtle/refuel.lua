local task = {}

function task.prepare()
  return turtle.getFuelLevel()
end

function task.perform(info)
  turtle.refuel(info.args.count)
end

function task.complete(info)
  return turtle.getFuelLevel() ~= info.prep
end

return task

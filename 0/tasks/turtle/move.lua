local task = {}

function task.prepare()
  return turtle.getFuelLevel()
end

function task.perform(info)
  turtle[info.args.direction]()
end

function task.complete(info)
  return turtle.getFuelLevel() == info.prep - 1
end

return task

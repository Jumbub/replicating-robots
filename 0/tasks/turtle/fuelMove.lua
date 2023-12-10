local task = {}

function task.prepare() end

function task.perform(info)
  if turtle.getFuelLevel() < 1 then
    return { requeue = true, queue = { id = "turtle.refuel", count = 1 } }
  else
    return { requeue = false, queue = { id = "turtle.move", direction = info.args.direction } }
  end
end

function task.complete(info) end

return task

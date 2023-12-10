local task = {}

function task.prepare()
  return turtle.getFuelLevel()
end

function task.perform()
  turtle.back()
end

function task.complete(prep)
  os.reboot()
end

return task

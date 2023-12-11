local t = {}

function t.idempotent(info)
  assert(info.temp.position, "Unsupported state for action")
end

return t

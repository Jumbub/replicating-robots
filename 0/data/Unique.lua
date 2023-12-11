local Unique = {}

function Unique.id()
  sleep(0.000001) -- ensure unique
  return tostring(os.day("utc")) .. tostring(os.time("utc"))
end

return Unique

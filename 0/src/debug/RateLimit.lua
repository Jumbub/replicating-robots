local RateLimit = {}

function RateLimit.fn(seconds, fn)
  return function(...)
    sleep(seconds)
    return fn(...)
  end
end

return RateLimit

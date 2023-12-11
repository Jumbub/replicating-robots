local Formatter = {}

function Formatter.unknown(data, ...)
  if #{ ... } > 0 then
    return Formatter.unknown(data) .. ", " .. Formatter.unknown(...)
  end

  if type(data) == "string" then
    return textutils.serialiseJSON(data)
  end

  if type(data) == "table" then
    local output = "{"
    for key, value in pairs(data) do
      output = output .. " " .. key .. " = " .. Formatter.unknown(value) .. ", "
    end
    output = string.sub(output, 1, #output - 2) .. " "
    return output .. "}"
  end

  return tostring(data)
end

return Formatter

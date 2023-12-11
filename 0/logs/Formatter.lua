local Formatter = {}

function Formatter.unknown(data, ...)
  if #{ ... } > 0 then
    return Formatter.format(data) .. ", " .. Formatter.format(...)
  end

  if type(data) == "string" then
    return textutils.serialiseJSON(data)
  end

  if type(data) == "table" then
    local output = "{"
    for key, value in pairs(data) do
      output = output .. " " .. key .. " = " .. Formatter.format(value) .. ", "
    end
    output = string.sub(output, 1, #output - 2) .. " "
    return output .. "}"
  end

  return tostring(data)
end

return Formatter

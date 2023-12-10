local SerializedFile = {}

--- @param path string
--- @return table
function SerializedFile.read(path)
  local file = fs.open(path, "r")
  if not file then
    return {}
  end

  local contents = file.readAll()
  if not contents then
    return {}
  end

  local parsed = textutils.unserializeJSON(contents, { parse_empty_array = false })
  assert(type(parsed) == "table")

  return parsed
end

--- @param path string
--- @param data table
function SerializedFile.write(path, data)
  local file = fs.open(path, "w")
  if not file then
    error("cannot load file for serializing: " .. file)
  end

  return file.write(textutils.serializeJSON(data))
end

return SerializedFile

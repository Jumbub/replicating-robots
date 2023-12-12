local File = {}

--- @param path string
--- @return string|nil
function File.read(path)
  local file = fs.open(path, "r")
  if not file then
    return nil
  end

  local contents = file.readAll()
  file.close()
  return contents
end

--- @param path string
--- @param contents string
--- @return boolean Success status
function File.write(path, contents)
  local file = fs.open(path, "w")
  if not file then
    return false
  end

  file.write(contents)
  file.close()
  return true
end

--- @param path string
--- @param contents string
--- @return boolean Success status
function File.append(path, contents)
  local file = fs.open(path, "a")
  if not file then
    return false
  end

  file.write(contents)
  file.close()
  return true
end

return File

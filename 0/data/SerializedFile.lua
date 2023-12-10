local File = require("data.File")
local SerializedFile = {}

--- @param path string
function SerializedFile.read(path)
  return textutils.unserialize(File.read(path) or "")
end

--- @param path string
--- @return boolean Success status
function SerializedFile.write(path, contents)
  return File.write(path, textutils.serialize(contents))
end

return SerializedFile

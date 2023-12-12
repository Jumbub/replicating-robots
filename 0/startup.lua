local success, error = pcall(require, "src.main")
if not success then
  printError(error)
  printError("\nFailed during execution of main.lua")

  local f = fs.open("logs.txt", "a")
  if f then
    f.writeLine(error)
    f.close()
  end
end

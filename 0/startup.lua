local function tryWritingError(error)
  local f = fs.open("logs.txt", "a")
  if f then
    f.writeLine(error)
    f.close()
  end
end

local success, error = pcall(require, "main")
if not success then
  printError("Failed during execution of main.lua")
  pcall(tryWritingError, error)
end

print("Rebooting in 5 seconds.")
sleep(5)
os.reboot()

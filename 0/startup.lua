local success, error = pcall(require("main"))
if not success then
  printError(error)
end

print("\nRebooting in 5 seconds.")
sleep(5)
os.reboot()

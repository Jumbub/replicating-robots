package.path = "/?;/?.lua;/?/init.lua;" .. package.path

if os.getComputerID() == 0 then
	require("apps.god")
end

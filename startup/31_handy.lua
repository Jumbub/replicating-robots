package.path = "/?;/?.lua;/?/init.lua;" .. package.path

if os.getComputerID() == 4 then
	require("apps.handy")
end

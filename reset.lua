local commands = require("world.commands")

local mode, size = ...
commands[mode or "clone"](size or 1)

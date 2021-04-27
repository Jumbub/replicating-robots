-- IDE fixes
_G.turtle = turtle
_G.colors = colors
_G.term = term
_G.textutils = textutils
_G.fs = fs
_G.exec = exec

-- Load external packages
require("lib")

-- Load local packages
_G.c = require("common.util")
_G.c.chest = require("common.chest")
_G.c.craft = require("common.craft")
_G.c.dig = require("common.dig")
_G.c.fuel = require("common.fuel")
_G.c.inspect = require("common.inspect")
_G.c.inventory = require("common.inventory")
_G.c.leaf = require("common.leaf")
_G.c.move = require("common.move")
_G.c.report = require("common.report")
_G.c.task = require("common.task")
_G.c.tree = require("common.tree")
_G.c.turn = require("common.turn")
_G.c.util = require("common.util")

-- Create aliases
_G.dd = c.report.debug

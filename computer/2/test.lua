require("common")

function x()
	dd("ohno!")

	c.report.debug("this is a debug", { debug = true })
	c.report.warning("this is a warning", { warning = true })
	c.report.info("this is a info", { info = true })
	c.report.error("this is a error", { error = true })
end

x()

-- dd(c.leaf.collect(2))

-- print(chest.stashExceptSingle("log", function()
-- 	print("done")
-- 	return true
-- end))

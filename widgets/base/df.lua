local awful = require("awful")

DfWidget = {
	timeout = 15
}

function DfWidget:new(con)
	con = con or {}
	setmetatable(con, self)
	self.__index = self
	return con
end

-- TODO: Refactor
function DfWidget:render_inner()
	return awful.widget.watch(
		os.getenv("HOME") .. "/Documents/scripts/awesome-df.sh",
		self.timeout,
		function(widget, stdout)
			widget.markup = stdout
		end
	)
end

return DfWidget

local awful = require("awful")
local naughty = require("naughty")

DfWidget = {
	timeout = 15
}

function DfWidget:new(con)
	con = con or {}
	setmetatable(con, self)
	self.__index = self
	return con
end

function DfWidget:render_inner()
	return awful.widget.watch("df -h /", self.timeout, function(widget, stdout)
		local i, from, to = 1, 1, 1

		while true do
			from, to = string.find(stdout, " %d-G", from + 1)
			if i == 3 or from == nil then
				break
			end
			i = i + 1
		end

		widget.markup = string.sub(stdout, from + 1, to)
	end)
end

return DfWidget

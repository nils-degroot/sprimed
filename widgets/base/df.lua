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

function DfWidget:render_inner()
	return awful.widget.watch("df -h /", self.timeout, function(widget, stdout)
		local i, from, to = 1, 1, 1

		while true do
			from, to = stdout:find(" %d-G", from + 1)
			if i == 3 or from == nil then
				break
			end
			i = i + 1
		end

		if from == nil then
			widget.markup = "Failed to find info"
		else
			widget.markup = stdout:sub(from + 1, to)
		end

	end)
end

return DfWidget

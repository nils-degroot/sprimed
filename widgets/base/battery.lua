local awful = require("awful")

BatteryWidget = {
	timeout = 60
}

function BatteryWidget:new(con)
	con = con or {}
    setmetatable(con, self)
    self.__index = self
    return con
end

function BatteryWidget:render_inner()
	return awful.widget.watch("acpi", self.timeout, function(widget, stdout)
		widget:set_text(stdout:match("%d+%%"))
	end)
end

return BatteryWidget

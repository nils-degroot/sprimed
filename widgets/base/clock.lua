local wibox = require("wibox")

ClockWidget = { }

function ClockWidget:new(con)
    con = con or {}
    setmetatable(con, self)
    self.__index = self
    return con
end

function ClockWidget:render_inner()
	return wibox.widget.textclock()
end

return ClockWidget

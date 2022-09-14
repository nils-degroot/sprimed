local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")

EmptyWidget = { }

function EmptyWidget:new(con)
	con = con or {}
	setmetatable(con, self)
	self.__index = self
	return con
end

function EmptyWidget:render_inner()
	return awful.widget.watch("hostname", 0, function(_, _) end)
end

TwoSidedBase = {
	-- Left style
	icon = "",
	left_font = beautiful.font,
	left_bg = beautiful.bg_focus,
	left_margin_left = 5,
	left_margin_right = 2,
	-- Right style
	right_bg = beautiful.bg_dark,
	right_margin_left = 5,
	right_margin_right = 5,
	right_inner = EmptyWidget
}

function TwoSidedBase:new(con)
	con = con or {}
	setmetatable(con, self)
	self.__index = self
	return con
end

function TwoSidedBase:render()
	return wibox.widget {
		{
		    {
		        {
		            markup = self.icon,
					font = self.left_font,
		            widget = wibox.widget.textbox
		        },
		        widget = wibox.container.margin,
				left = self.left_margin_left,
				right = self.left_margin_right
		    },
		    widget = wibox.container.background,
			bg = self.left_bg
		},
		{
		    {
				self.right_inner:render_inner(),
		        widget = wibox.container.margin,
				left = self.right_margin_left,
				right = self.right_margin_right
		    },
		    widget = wibox.container.background,
		    bg = self.right_bg
		},
		layout = wibox.layout.fixed.horizontal
	}
end

return TwoSidedBase

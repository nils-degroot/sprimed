local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local config = {
	-- Icon
	["icon"] = " ",
	["bg_left"] = beautiful.bg_focus,
	["icon_margin_left"] = 5,
	["icon_margin_right"] = 2,
	-- Text
	["bg_right"] = beautiful.bg_dark,
	["text_margin_left"] = 5,
	["text_margin_right"] = 5,
	-- Etc
	["timeout"] = 60
}

-- Widget containing the output of awesome-df
return {
	["config"] = config,
	["widget"] = function(custom_config)
		local local_config = custom_config or config

		return wibox.widget {
			{
			    {
			        {
			            markup = local_config.icon,
			            widget = wibox.widget.textbox
			        },
			        widget = wibox.container.margin,
					left = local_config.icon_margin_left,
					right = local_config.icon_margin_right
			    },
			    widget = wibox.container.background,
				bg = local_config.bg_left
			},
			{
			    {
					awful.widget.watch(os.getenv("HOME") .. "/Documents/scripts/awesome-df.sh", local_config.timeout, function(widget, stdout)
						widget.markup = stdout
			        end),
			        widget = wibox.container.margin,
					left = local_config.text_margin_left,
					right = local_config.text_margin_right
			    },
			    widget = wibox.container.background,
			    bg = local_config.bg_right
			},
			layout = wibox.layout.fixed.horizontal
		}
	end
}

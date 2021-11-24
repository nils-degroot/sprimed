local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- Util methods
local function get_mem_string(stdout)
	local result = ""

	-- Loop through lines
	for line in stdout:gmatch("[^\n]*\n?") do
		if line:find("^Mem") ~= nil then
			-- Define some numbers
			local i, total, used = 0, 0, 0

			-- Loop through entries of `free -m`
			for entry in line:gmatch("(%d+)%s*") do
				if i == 0 then
					-- 0 = total
					total = entry
				elseif i == 1 then
					-- 1 = used
					used = entry
					break
				end
				i = i + 1
			end

			-- Format to (`precent used`% `current` MiB)
			result = string.format("%.1f%% %i MiB", (used / total * 100), used)
			break
		end
	end

	return result
end

local config = {
    -- Icon
    ["icon"] = " ",
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
					awful.widget.watch("free -m", local_config.timeout, function(widget, stdout)
						widget.markup = get_mem_string(stdout)
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

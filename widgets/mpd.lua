local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- MPD status singal
local visibillity_signal = "cool_widgets::mpd_status_widget::visible"

local config = {
    -- Left block
	["icon"] = " ",
    ["bg_left"] = beautiful.bg_focus,
    ["icon_margin_left"] = 5,
    ["icon_margin_right"] = 2,
    -- Text
    ["bg_right"] = beautiful.bg_dark,
    ["text_margin_left"] = 5,
    ["text_margin_right"] = 5,
	-- Inner icons
    ["icon_playing"] = "契 ",
    ["icon_paused"] = " ",
    ["icon_stopped"] = "",
    -- Etc
    ["timeout"] = 10,
    ["hide_when_stopped"] = true
}

return {
	["config"] = config,
	["widget"] = function(custom_config)
		local local_config = custom_config or config
		local widget_mpd

		-- Inner watch widget of the mpd widget
		local mpd_watch_widget = awful.widget.watch("mpc status", 10, function(self, stdout)
			local lines = {}
			local lines_counted = 0

			-- Read through all line
			for line in stdout:gmatch("([^\n]*)\n?") do
			    lines[lines_counted] = line
			    lines_counted = lines_counted + 1
			end

			if lines_counted == 1 then
			    -- If only one line is read, the music is stopped
			    self.markup = local_config.icon_stopped

				-- Hide the widget if configured to
				if config.hide_when_stopped then
				    widget_mpd:emit_signal(visibillity_signal, false)
				end
			else
				if lines[1]:find("^%[playing%]") ~= nil then
				    -- If the second line start with [playing], The music if playing
				    self.markup = local_config.icon_playing .. lines[0]
				else
				    -- Otherwise, the music is paused
				    self.markup = local_config.icon_paused .. lines[0]
				end

				if local_config.hide_when_stopped then
					-- Show the widget if hidden
				    widget_mpd:emit_signal(visibillity_signal, true)
				end
			end
		end)

		-- Wrapper arround the mpd widget
		widget_mpd = wibox.widget {
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
					mpd_watch_widget,
			        widget = wibox.container.margin,
					left = local_config.text_margin_left,
					right = local_config.text_margin_right
			    },
			    widget = wibox.container.background,
			    bg = local_config.bg_right
			},
			layout = wibox.layout.fixed.horizontal
		}

		-- Connect the show signal to the widget
		widget_mpd:connect_signal(visibillity_signal, function(self, show)
			self.visible = show
		end)

		return widget_mpd
	end
}

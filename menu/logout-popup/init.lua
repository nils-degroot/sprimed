local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local capi = { keygrabber = keygrabber }

local default_config = {
	-- Global
	["default_text"] = "Uptime",
	["title_font"] = "JetBrainsMono Nerd Font 12",
	["icon_path"] = os.getenv("HOME") .. "/.config/awesome/sprimed/menu/logout-popup",
	["close_hook"] = function() end,
	["stop_overlay_key"] = "Escape",
	-- Wrapper style
	["wrapper_bg"] = beautiful.bg_dark,
	["wrapper_border_color"] = beautiful.border_focus,
	["wrapper_border_width"] = beautiful.border_width,
	-- Button hotkeys
	["button_poweroff_key"] = "s",
	["button_reboot_key"] = "r",
	["button_lock_key"] = "l",
	-- Buttons methods
	["button_poweroff_hook"] = function()
		awful.spawn("poweroff")
	end,
	["button_reboot_hook"] = function()
		awful.spawn("reboot")
	end,
	["button_lock_hook"] = function()
		awful.spawn("lock")
	end,
	-- Button style
	["button_bg"] = beautiful.bg_normal,
}

local function launch(custom_config)
	local config = custom_config or default_config

	-- Wrapper containing all
	local wrapper = wibox {
		bg = config.wrapper_bg,
		ontop = true,
		height = 190,
		width = 360,
		border_color = config.wrapper_border_color,
		border_width = config.wrapper_border_width
	}

	-- Function to stop the overlay
	local stop_overlay = function()
	    capi.keygrabber.stop()
	    wrapper.visible = false
		config.close_hook()
	end

	-- Textbox containing hover information
	local textbox = wibox.widget {
		text = config.default_text,
		valign = "center",
		font = config.title_font,
		forced_height = 100,
		widget = wibox.widget.textbox
	}

	textbox:connect_signal("logout_popup::update_text", function (elem, text)
		elem.text = text
	end)

	-- Generate button
	local function generate_button(inner, press)
		local widget = wibox.widget {
			{
				{
					{
						image = config.icon_path .. "/" .. inner .. ".svg",
						resize = true,
						layout = wibox.widget.imagebox
					},
					layout = wibox.container.place
				},
				margins = 32,
				layout = wibox.container.margin
			},
			bg = config.button_bg,
			forced_height = 100,
			forced_width = 100,
			layout = wibox.container.background
		}

		-- Signals
		widget:connect_signal("mouse::enter", function(elem)
			elem:set_bg(beautiful.bg_focus)
			textbox:emit_signal("logout_popup::update_text", (inner:gsub("^%l", string.upper)))
		end)

		widget:connect_signal("mouse::leave", function(elem)
			elem:set_bg(beautiful.bg_normal)
			textbox:emit_signal("logout_popup::update_text", config.default_text)
		end)

		widget:connect_signal("button::press", function()
			stop_overlay()
			press()
		end)

		return widget
	end

	wrapper:setup {
		{
			{
				{
					{
						{
							{
								textbox,
								left = 10,
								right = 10,
								layout = wibox.container.margin
							},
							fg = beautiful.fg_urgent,
							bg = beautiful.border_focus,
							layout = wibox.container.background
						},
						{
							-- Uptime widget
							awful.widget.watch("uptime -p", 60, function(elem, out)
								elem.font = config.title_font
								elem:set_text(out:match("up%s(.+)"))
							end),
							margins = 10,
							layout = wibox.container.margin
						},
						border_color = beautiful.border_focus,
						border_width = beautiful.border_width,
						layout = wibox.layout.align.horizontal
					},
					bg = beautiful.bg_normal,
					layout = wibox.container.background
				},
				forced_height = 50,
				margins = 1,
				color = beautiful.border_focus,
				layout = wibox.container.margin
			},
			{
				generate_button("power", config.button_poweroff_hook),
				generate_button("reboot", config.button_reboot_hook),
				generate_button("lock", config.button_lock_hook),
				spacing = 10,
				forced_height = 100,
				layout = wibox.layout.fixed.horizontal
			},
			spacing = 10,
			layout = wibox.layout.fixed.vertical
		},
		margins = 20,
		layout = wibox.container.margin
	}

	-- Display the overlay
	wrapper.visible = true
	wrapper.screen = mouse.screen
	awful.placement.centered(wrapper)

	-- Run the keygrabber
	capi.keygrabber.run(function(_, key, event)
		if event == "release" then
			-- Ignore all release events
			return
		end

		if key then
			if key == config.stop_overlay_key then
				stop_overlay()
			elseif key == config.button_poweroff_key then
				stop_overlay()
				config.button_poweroff_hook()
			elseif key == config.button_reboot_key then
				stop_overlay()
				config.button_reboot_hook()
			elseif key == config.button_lock_key then
				stop_overlay()
				config.button_lock_hook()
			end
		end
	end)
end

return {
	["launch"] = launch
}

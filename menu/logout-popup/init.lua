local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local capi = { keygrabber = keygrabber }

local title_font = "JetBrainsMono Nerd Font 12"
local icon_path = os.getenv("HOME") .. "/.config/awesome/sprimed/menu/logout-popup/"

local default_text = "Uptime"

local wrapper = wibox {
	bg = beautiful.bg_dark,
	ontop = true,
	height = 190,
	width = 360,
	border_color = beautiful.border_focus,
	border_width = beautiful.border_width
}

local stop_overlay = function()
    capi.keygrabber.stop()
    wrapper.visible = false
end

-- Textbox containing hover information
local textbox = wibox.widget {
	text = default_text,
	valign = "center",
	font = title_font,
	forced_height = 100,
	widget = wibox.widget.textbox
}

textbox:connect_signal("logout_popup::update_text", function (elem, text)
	elem.text = text
end)

local functions = {
	["poweroff"] = function()
		awful.spawn("poweroff")
	end,
	["reboot"] = function()
		awful.spawn("reboot")
	end,
	["lock"] = function()
		awful.spawn("lock")
	end
}

local function generate_button(inner, press)
	local box = wibox.widget {
		{
			{
				{
					image = icon_path .. inner .. ".svg",
					resize = true,
					layout = wibox.widget.imagebox
				},
				layout = wibox.container.place
			},
			margins = 32,
			layout = wibox.container.margin
		},
		bg = beautiful.bg_normal,
		forced_height = 100,
		forced_width = 100,
		layout = wibox.container.background
	}

	box:connect_signal("mouse::enter", function(elem)
		elem:set_bg(beautiful.bg_focus)
		textbox:emit_signal("logout_popup::update_text", (inner:gsub("^%l", string.upper)))
	end)

	box:connect_signal("mouse::leave", function(elem)
		elem:set_bg(beautiful.bg_normal)
		textbox:emit_signal("logout_popup::update_text", default_text)
	end)

	box:connect_signal("button::press", function()
		stop_overlay()
		press()
	end)

	return box
end

local function launch()
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
							awful.widget.watch("uptime -p", 60, function(elem, out)
								elem.font = title_font
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
				generate_button("power", functions.poweroff),
				generate_button("reboot", functions.reboot),
				generate_button("lock", functions.lock),
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

	wrapper.visible = true
	wrapper.screen = mouse.screen
	awful.placement.centered(wrapper)

	capi.keygrabber.run(function(_, key, event)
		if event == "release" then
			return
		end

		if key then
			if key == 'Escape' then
				stop_overlay()
			elseif key == "s" then
				stop_overlay()
				functions.poweroff()
			elseif key == "r" then
				stop_overlay()
				functions.reboot()
			elseif key == "l" then
				stop_overlay()
				functions.lock()
			end
		end
	end)
end

return {
	["launch"] = launch
}

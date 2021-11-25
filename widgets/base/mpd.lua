local awful = require("awful")

MpdWidget = {
	-- Inner icons
    icon_playing = "契 ",
    icon_paused = " ",
    icon_stopped = "",
    -- Etc
    timeout = 10,
	tick_hook = function(_) end,
	tick_key_active = "active",
	tick_key_stopped = "stopped",
}

function MpdWidget:new(con)
    con = con or {}
    setmetatable(con, self)
    self.__index = self
    return con
end

function MpdWidget:render_inner()
	return awful.widget.watch("mpc status", self.timeout, function(widget, stdout)
		local lines = {}
		local lines_counted = 0

		-- Read through all line
		for line in stdout:gmatch("([^\n]*)\n?") do
		    lines[lines_counted] = line
		    lines_counted = lines_counted + 1
		end

		if lines_counted == 1 then
		    -- If only one line is read, the music is stopped
		    widget.markup = self.icon_stopped
			self.tick_hook(self.tick_key_stopped)
		else
			if lines[1]:find("^%[playing%]") ~= nil then
			    -- If the second line start with [playing], The music if playing
			    widget.markup = self.icon_playing .. lines[0]
			else
			    -- Otherwise, the music is paused
			    widget.markup = self.icon_paused .. lines[0]
			end

			self.tick_hook(self.tick_key_active)
		end
	end)
end

return MpdWidget

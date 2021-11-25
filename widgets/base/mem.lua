local awful = require("awful")

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

-- Actual widget
MemWidget = {
	timeout = 60
}

function MemWidget:new(con)
    con = con or {}
    setmetatable(con, self)
    self.__index = self
    return con
end

function MemWidget:render_inner()
	return awful.widget.watch("free -m", self.timeout, function(widget, stdout)
		widget.markup = get_mem_string(stdout)
	end)
end

return MemWidget

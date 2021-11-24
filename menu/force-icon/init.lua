local gears = require("gears")

return function(mappings)
	client.connect_signal("manage", function(c)
	    for class, path in pairs(mappings) do
			if c.class == class then
			    local icon = gears.surface(path)
			    c.icon = icon._native
			end
	    end
	end)
end

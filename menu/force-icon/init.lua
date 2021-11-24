local gears = require("gears")

-- Client icon management
-- Base path to find icons
local icon_path = os.getenv("HOME") .. "/.icons/Gruvbox-Material-Dark/"

-- Icons for given client class
local icon_mapping = {
    ["Firefox"] = icon_path .. "32x32/categories/firefox-nightly.svg",
    ["Alacritty"] = icon_path .. "32x32/apps/Alacritty.svg",
    ["Thunderbird"] = icon_path .. "32x32/categories/thunderbird.svg",
    ["Surf"] = icon_path .. "32x32/categories/internet-web-browser.svg",
    ["Steam"] = icon_path .. "32x32/categories/steam.svg",
    ["Sxiv"] = icon_path .. "32x32/apps/among-us.svg"
}

-- Set client icon
client.connect_signal("manage", function(c)
    for class, icon_path in pairs(icon_mapping) do
		if c.class == class then
		    local icon = gears.surface(icon_path)
		    c.icon = icon._native
		end
    end
end)

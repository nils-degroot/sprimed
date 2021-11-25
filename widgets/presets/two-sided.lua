local BaseWidget = require((...):match("(.*)%.presets") .. ".styles.two-sided")

local base_namespace = (...):match("(.*)%.presets") .. ".base."

return {
	battery = BaseWidget:new {
		icon = "",
		left_margin_right = 5,
		right_inner = require(base_namespace .. "battery"):new()
	},
	clock = BaseWidget:new {
		icon = " ",
		right_margin_left = 0,
		right_margin_right = 0,
		right_inner = require(base_namespace .. "clock"):new()
	},
	df = BaseWidget:new {
		icon = " ",
		right_inner = require(base_namespace .. "df"):new()
	},
	mem = BaseWidget:new {
		icon = " ",
		right_inner = require(base_namespace .. "mem"):new()
	},
	mpd = BaseWidget:new {
		icon = " ",
		right_inner = require(base_namespace .. "mpd"):new()
	}
}

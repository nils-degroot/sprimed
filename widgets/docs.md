# Widgets

![](./widgets.png)

Init lua returns all the widget in a table. call this if you're planning on
using all the widgets. Otherwise, you can call each widget individually.

A individual widget contains at least two attributes:

- `config` The default configuration for the widget
- `widget` A method that returns the actual widget. Has one argument for a
  custom config. Will be the default config is left `nil`

```lua
-- Include widgets
local mem_widget = require("src.widgets.mem")

-- Configure
local mem_config = mem_widget.config
mem_config.bg_left = "#00ff00"

-- Render the widget
mem_widget.widget(mem_config)
```

## Battery

Shows the percentage of battery left.

Requires acpi to be installed.

### Default config

```lua
local config = {
    -- Icon
    ["icon"] = "",
    ["bg_left"] = beautiful.bg_focus,
    ["icon_margin_left"] = 5,
    ["icon_margin_right"] = 5,
    -- Text
    ["bg_right"] = beautiful.bg_dark,
    ["text_margin_left"] = 5,
    ["text_margin_right"] = 5,
    -- Etc
    ["timeout"] = 15
}
```

## Clock

Shows the time as text

### Default config

```lua
local config = {
    -- Icon
    ["icon"] = " ",
    ["bg_left"] = beautiful.bg_focus,
    ["icon_margin_left"] = 5,
    ["icon_margin_right"] = 2,
    -- Text
    ["bg_right"] = beautiful.bg_dark,
    ["text_margin_left"] = 0,
    ["text_margin_right"] = 0,
}
```

## Df

Shows the gig left on the main disk.

### Default config

```lua
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
```

## Mem

Shows the current memory used

### Default config

```lua
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
```

## Mpd

Shows the current song and if it is playing.

Requires mpd and mpc to be installed.

### Default config

```lua
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
```

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 12
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0, }
config.window_close_confirmation = "NeverPrompt"
config.colors = { foreground = 'white', cursor_bg = 'white', cursor_fg = 'black', }
config.window_decorations = "RESIZE"
config.color_scheme = 'rose-pine'
config.enable_tab_bar = false
config.max_fps = 120

return config

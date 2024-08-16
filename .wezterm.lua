local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 12
config.colors = {
    cursor_bg = 'white',
    cursor_fg = 'black',
}
config.color_scheme = 'catppuccin-macchiato'
config.enable_tab_bar = false
config.max_fps = 120

return config

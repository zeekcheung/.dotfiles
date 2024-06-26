local wezterm = require 'wezterm'
local config = wezterm.config_builder()

require('config.misc').setup(config)
require('config.tab').setup(config)
require('config.mouse').setup(config)
require('config.keys').setup(config)
require('config.links').setup(config)

return config

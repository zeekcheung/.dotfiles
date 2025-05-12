local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- font
config.font = wezterm.font("Maple Mono NF")
config.font_size = 16
config.freetype_load_target = "HorizontalLcd"
config.underline_thickness = 2
-- config.underline_position = -6

-- color
config.color_scheme = "tokyonight_moon"

-- cursor
config.animation_fps = 24
config.default_cursor_style = "BlinkingBlock"
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true

-- dimensions
config.initial_cols = 80
config.initial_rows = 20
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_scroll_bar = false

-- tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_style = {
  window_hide = " - ",
  window_maximize = " + ",
  window_close = " ✗ ",
  window_hide_hover = " - ",
  window_maximize_hover = " + ",
  window_close_hover = " ✗ ",
}
config.tab_max_width = 32

-- command palette
config.command_palette_font_size = 16
config.command_palette_fg_color = "#828bb8"

-- misc
config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"

local smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
  else
    window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
  end
end)

-- keys
-- `https://wezterm.org/config/keys.html#configuring-key-assignments`
-- `https://wezterm.org/config/lua/keyassignment/index.html`
config.keys = {
  { key = "Space", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  { key = "d", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "|", mods = "CTRL|SHIFT", action = smart_split },
  { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
}

if wezterm.target_triple:find("windows") then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = false
  -- config.default_prog = { "pwsh.exe", "-NoLogo" }
  config.default_prog = { "nu.exe" }
  config.launch_menu = {
    {
      label = wezterm.nerdfonts.cod_terminal_cmd .. "  cmd.exe",
      args = { "cmd.exe", "/k" },
    },
    {
      label = wezterm.nerdfonts.cod_terminal_powershell .. "  pwsh.exe",
      args = { "pwsh.exe", "-NoLogo" },
    },
    {
      label = wezterm.nerdfonts.cod_terminal_powershell .. "  powershell.exe",
      args = { "powershell.exe", "-NoLogo" },
    },
    {
      label = wezterm.nerdfonts.cod_terminal_powershell .. "  nu.exe",
      args = { "nu.exe" },
    },
  }
end

-- Center new window on active screen
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local ratio = 0.7
  local width, height = screen.width * ratio, screen.height * ratio
  ---@diagnostic disable-next-line: unused-local
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = "ActiveScreen",
    },
  })
  window:gui_window():set_inner_size(width, height)
end)

return config

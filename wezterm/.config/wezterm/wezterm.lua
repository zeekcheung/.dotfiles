---@diagnostic disable: unused-local
local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- font
config.font = wezterm.font_with_fallback({
  "Maple Mono NF",
  "JetBrains Mono",
  "Cascadia Mono",
})
config.font_size = 16
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.underline_thickness = 2
config.underline_position = -6
config.warn_about_missing_glyphs = false

-- color
config.color_scheme = "tokyonight_moon"
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#2b2042",
      fg_color = "#c0c0c0",
    },
    inactive_tab = {
      bg_color = "#1b1032",
      fg_color = "#808080",
    },
    inactive_tab_hover = {
      bg_color = "#3b3052",
      fg_color = "#909090",
    },
    new_tab = {
      bg_color = "#1b1032",
      fg_color = "#808080",
    },
    new_tab_hover = {
      bg_color = "#3b3052",
      fg_color = "#909090",
    },
  },
}

-- window
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  active_titlebar_bg = "#2b2042",
  inactive_titlebar_bg = "#2b2042",
}

-- tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_bar_style = {
  window_hide = " - ",
  window_maximize = " + ",
  window_close = " ✗ ",
  window_hide_hover = " - ",
  window_maximize_hover = " + ",
  window_close_hover = " ✗ ",
}
config.tab_max_width = 32

-- dimensions
config.initial_cols = 80
config.initial_rows = 20
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_scroll_bar = false

-- cursor
config.animation_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "EaseIn"
config.cursor_blink_ease_out = "EaseOut"
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true

-- command palette
config.command_palette_font_size = 14
config.command_palette_fg_color = "#828bb8"
config.command_palette_bg_color = "#2b2042"

-- misc
config.audible_bell = "Disabled"

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
    {
      label = wezterm.nerdfonts.cod_terminal_linux .. "  wsl.exe",
      args = { "wsl.exe", "~" },
    },
  }
end

wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
  local action = default_action

  if button == "Right" then
    action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" })
  end

  window:perform_action(action, pane)

  -- Tell wezterm that we handled the event so that it doesn't perform it a second time.
  return false
end)

wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local window_width = config.initial_cols * config.font_size
  local window_height = config.initial_rows * config.font_size * 2.36

  local tab, pane, window = wezterm.mux.spawn_window({
    position = {
      x = (screen.width - window_width) / 2,
      y = (screen.height - window_height) / 2,
      origin = "ActiveScreen",
    },
  })
  window:gui_window():set_inner_size(window_width, window_height)
end)

-- smart splits
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
  default_amount = 1,
  direction_keys = {
    move = { "h", "j", "k", "l" },
    resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
  },
  modifiers = {
    move = "CTRL",
    resize = "CTRL",
  },
})

return config

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Environment
config.term = "wezterm"

-- Performance
config.enable_wayland = os.getenv("XDG_CURRENT_DESKTOP") ~= "GNOME"
config.front_end = "OpenGL"
-- config.front_end = config.enable_wayland and "WebGpu" or "OpenGL"
-- config.webgpu_power_preference = 'HighPerformance'

-- Appearence
config.color_scheme = "tokyonight-moon"
-- config.window_background_opacity = 0.90
config.animation_fps = 20
config.default_cursor_style = "BlinkingBlock"
config.force_reverse_video_cursor = true

-- Font
config.font = wezterm.font_with_fallback({
  { family = "Maple Mono NF", weight = "Regular", italic = false },
  { family = "JetBrains Mono", weight = "Regular", italic = false },
})
config.font_size = config.enable_wayland and 18 or 14
config.freetype_render_target = config.front_end == "WebGpu" and "Normal" or "HorizontalLcd"
config.freetype_load_flags = config.front_end == "WebGpu" and "NO_HINTING" or "DEFAULT"
config.underline_thickness = 2

-- Dimensions
config.initial_cols = 80
config.initial_rows = 20
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

-- Customize tab title
---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  -- local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  -- local process, other = title:match("^(%S+)%s*%-?%s*%s*(.*)$")
  -- title = string.format(" %s: %s %s ", tab.tab_index + 1, process, other or "")
  local process = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
  local title = string.format(" %s: %s ", tab.tab_index + 1, process)
  return {
    { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
    { Text = title },
  }
end)

-- Customize right status
---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("update-right-status", function(window, pane)
  local host = wezterm.hostname()
  local date = wezterm.strftime("%Y-%m-%d  %H:%M")
  local builtin_colorschemes = wezterm.get_builtin_color_schemes()
  local colorscheme = config.color_scheme
  local colors = builtin_colorschemes[colorscheme]
    or wezterm.color.load_scheme(wezterm.home_dir .. "/.config/wezterm/colors/" .. colorscheme .. ".toml")

  window:set_right_status(wezterm.format({
    { Foreground = { Color = colors.tab_bar.active_tab.fg_color } },
    { Text = string.format("%s  %s", host, date) },
  }))
end)

-- Customize window title
---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return tab.active_pane.title
end)

-- Command palette
config.command_palette_rows = 8
config.command_palette_bg_color = "#1b1b2b"
config.command_palette_fg_color = "#a9b1d6"
config.command_palette_font_size = 16

-- Misc
config.audible_bell = "Disabled"
config.default_workspace = "main"
config.window_close_confirmation = "NeverPrompt"

-- Key bindings
local mod = "CTRL|SHIFT"
config.keys = {
  { key = "c", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = mod, action = act.CloseCurrentPane({ confirm = false }) },
  { key = "n", mods = mod, action = act.ActivateTabRelative(1) },
  { key = "p", mods = mod, action = act.ActivateTabRelative(-1) },
  { key = "h", mods = mod, action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = mod, action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = mod, action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = mod, action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = mod, action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = mod, action = act.AdjustPaneSize({ "Down", 6 }) },
  { key = "LeftArrow", mods = mod, action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = mod, action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "Space", mods = mod, action = act.ActivateCopyMode },
  { key = "PageUp", mods = "", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "", action = act.ScrollByPage(1) },
  { key = "F1", mods = "", action = act.ActivateCommandPalette },
  { key = "F11", mods = "", action = act.ToggleFullScreen },
  -- { key = "\\", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- { key = "|", mods = mod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  {
    key = "\\",
    mods = "CTRL",
    action = wezterm.action_callback(function(_, pane)
      local pane_dimensions = pane:get_dimensions()
      local direction = pane_dimensions.pixel_width >= pane_dimensions.pixel_height and "Right" or "Bottom"
      local cwd = pane:get_current_working_dir().path
      pane:split({ direction = direction, cwd = cwd })
    end),
  },
}

-- Mouse bindings
config.mouse_bindings = {
  { event = { Down = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.Nop },
  { event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

-- Windows specific settings
if wezterm.target_triple:find("windows") then
  config.dpi = 120
  -- config.default_prog = { "pwsh", "-nologo" }
  -- config.default_domain = "WSL:Ubuntu-22.04"
  config.launch_menu = {
    { label = "PowerShell", args = { "pwsh", "-nologo" } },
    { label = "Ubuntu-22.04", args = { "wsl", "~" } },
    { label = "cmd", args = { "cmd", "/k" } },
  }
end

return config

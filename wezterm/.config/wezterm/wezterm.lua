local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Environment
config.term = "wezterm"
config.enable_wayland = true

-- Performance
config.front_end = config.enable_wayland and "WebGpu" or "OpenGL"
-- config.webgpu_power_preference = 'HighPerformance'

-- Appearence
config.color_scheme = "Tokyo Night Moon"
-- wezterm.add_to_config_reload_watch_list(config.color_scheme .. '.toml')
-- config.window_background_opacity = 0.90
config.animation_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.force_reverse_video_cursor = true

-- Font
config.font = wezterm.font_with_fallback({
  { family = "Maple Mono NF", weight = "Regular", italic = false },
  { family = "JetBrains Mono", weight = "Regular", italic = false },
})
config.font_size = 18

if config.front_end ~= "WebGpu" then
  config.freetype_load_target = "HorizontalLcd"
  config.underline_thickness = 2
  config.underline_position = -6
end

-- Dimensions
config.initial_cols = 80
config.initial_rows = 20
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.unzoom_on_switch_pane = true

wezterm.on("update-right-status", function(window, _)
  local host = wezterm.hostname()
  local date = wezterm.strftime("%Y-%m-%d  %H:%M")
  local schemes = wezterm.get_builtin_color_schemes()
  local scheme = schemes[config.color_scheme]

  -- Make it italic and underlined
  window:set_right_status(wezterm.format({
    { Background = { Color = scheme.tab_bar.active_tab.bg_color } },
    { Foreground = { Color = scheme.tab_bar.active_tab.fg_color } },
    -- { Attribute = { Underline = "Single" } },
    { Attribute = { Italic = false } },
    { Text = string.format("%s  %s", host, date) },
  }))
end)

-- Command palette
-- config.command_palette_rows = 8
-- config.command_palette_bg_color = '#1b1b2b'
-- config.command_palette_fg_color = '#a9b1d6'
-- config.command_palette_font_size = 16

-- Misc
config.audible_bell = "Disabled"
config.default_workspace = "main"
config.window_close_confirmation = "NeverPrompt"

local mod = "CTRL|SHIFT"

-- Key bindings
config.keys = {
  -- Active command palette
  { key = "F1", mods = "", action = act.ActivateCommandPalette },
  -- Toggle fullscreen
  { key = "F11", mods = "", action = act.ToggleFullScreen },
  -- Copy mode(Vim mode)
  { key = "Space", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },

  -- ScrollPageUp
  { key = "PageUp", mods = "NONE", action = act.ScrollByPage(-1) },
  -- ScrollPageDown
  { key = "PageDown", mods = "NONE", action = act.ScrollByPage(1) },

  -- Vertical split
  { key = "\\", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Horizontal split
  { key = "|", mods = mod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Close split panel
  { key = "x", mods = mod, action = act.CloseCurrentPane({ confirm = false }) },

  -- Move between split panels
  { key = "h", mods = mod, action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = mod, action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = mod, action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = mod, action = act.ActivatePaneDirection("Right") },

  -- Resize panels
  { key = "UpArrow", mods = mod, action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = mod, action = act.AdjustPaneSize({ "Down", 6 }) },
  { key = "LeftArrow", mods = mod, action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = mod, action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Create new tab
  { key = "c", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  -- Close current tab
  { key = "q", mods = mod, action = wezterm.action.CloseCurrentTab({ confirm = false }) },

  -- Move between tabs
  { key = "n", mods = mod, action = act.ActivateTabRelative(1) },
  { key = "p", mods = mod, action = act.ActivateTabRelative(-1) },
  { key = "Tab", mods = mod, action = act.ActivateTabRelative(1) },
}

-- Mouse bindings
config.mouse_bindings = {
  -- Bind 'Up' event of CTRL-Click to open hyperlinks
  { event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  { event = { Down = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.Nop },
  -- Right click to paste from clipboard
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
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

-- Hyperlink
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Make username/project paths clickable. This implies paths like the following are for GitHub.
-- As long as a full URL hyperlink regex exists above this it should not match a full URL to
-- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

-- Linkify things that look like URLs with numeric addresses as hosts.
-- E.g. http://127.0.0.1:8000 for a local development server,
-- or http://192.168.1.1 for the web interface of many routers.
table.insert(config.hyperlink_rules, {
  regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
  format = "$0",
})

-- Format window title
---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return tab.active_pane.title
end)

if wezterm.target_triple:find("windows") then
  -- Windows shell
  -- config.default_prog = { "pwsh", "-nologo" }
  config.default_prog = { "nu" }
  -- WSL
  -- config.default_domain = "WSL:Ubuntu-22.04"

  config.launch_menu = {
    { label = "PowerShell", args = { "pwsh", "-nologo" } },
    { label = "Ubuntu-22.04", args = { "wsl", "~" } },
    { label = "cmd", args = { "cmd", "/k" } },
  }

  -- Change scale to 125%: 96 * 1.25 = 120
  config.dpi = 120
end

return config

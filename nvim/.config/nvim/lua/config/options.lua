-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local map = vim.keymap.set

opt.backup = false
opt.swapfile = false
opt.helpheight = 10
opt.showmode = false
opt.showcmd = false
opt.pumblend = 0
opt.pumheight = 10
opt.list = false
opt.foldtext = "foldtext()"
opt.winborder = "rounded"

vim.g.backdrop = 100

if vim.uv.os_uname().sysname == "Windows_NT" then
  opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  opt.shellcmdflag =
    "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit %LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

if vim.g.neovide then
  vim.opt.winborder = "none"
  vim.g.backdrop = 60
  vim.g.snacks_animate = false

  vim.o.guifont = "Maple Mono NF:h14"
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_scale_factor = 1.25
  vim.g.neovide_floating_corner_radius = 0.2
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_stroke_scale = 0.1
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_smooth_blink = true

  map("v", "<c-s-c>", '"+y', { desc = "Copy selection" })
  map({ "n", "v" }, "<c-s-v>", '"+p', { desc = "Paste" })
  map({ "c", "i" }, "<c-s-v>", "<c-r>+", { desc = "Paste" })

  -- stylua: ignore
  local function change_scale_factor(delta) vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta end
  -- stylua: ignore
  map("n", "<c-=>", function() change_scale_factor(1.25) end, { desc = "Zoom in" })
  -- stylua: ignore
  map("n", "<c-->", function() change_scale_factor(1/1.25) end, { desc = "Zoom out" })
end

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
opt.spelllang = "en_us,cjk"
opt.foldtext = "foldtext()"
-- opt.winborder = "rounded"

-- vim.g.backdrop = 100

if vim.fn.has("win32") then
  vim.g.python3_host_prog = vim.fn.expand("~/AppData/Local/Programs/Python/Python313/python.exe")

  if vim.fn.executable("nu") then
    opt.shell = "nu"
    opt.shelltemp = false
    opt.shellredir = "out+err> %s"
    opt.shellcmdflag = "--stdin --no-newline -c"
    opt.shellxescape = ""
    opt.shellxquote = ""
    opt.shellquote = ""

    vim.g.termcmd = "nu.exe"
  else
    opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
    opt.shellcmdflag =
      "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    opt.shellredir = "2>&1 | %{ '$_' } | Out-File %s; exit $LastExitCode"
    opt.shellpipe = "2>&1 | %{ '$_' } | Tee-Object %s; exit $LastExitCode"
    opt.shellquote = ""
    opt.shellxquote = ""

    vim.g.termcmd = string.format("%s.exe -NoLogo", vim.api.nvim_get_option_value("shell", {}))
  end
end

if vim.g.neovide then
  vim.g.snacks_animate = false

  vim.o.guifont = "Maple Mono NF:h16:#e-subpixelantialias:#h-full"
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_scale_factor = 1
  vim.g.neovide_floating_corner_radius = 0.2
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_stroke_scale = 0.1
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_confirm_quit = false

  -- VSCode like smooth cursor
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_cursor_short_animation_length = 0.15
  vim.g.neovide_cursor_trail_size = 0

  -- vim.g.neovide_cursor_vfx_mode = "torpedo"

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

  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Set working directory to home if no directory is specified",
    group = vim.api.nvim_create_augroup("Neovide", { clear = true }),
    callback = function()
      local args = vim.v.argv
      if #args == 3 then
        vim.api.nvim_set_current_dir(vim.env.HOME)
      end
    end,
  })
end

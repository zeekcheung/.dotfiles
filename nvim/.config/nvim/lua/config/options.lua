-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.backup = false
opt.swapfile = false
opt.helpheight = 10
opt.showmode = false
opt.showcmd = false
opt.pumblend = 0
opt.pumheight = 10
opt.list = false
opt.foldtext = "foldtext()"

if vim.uv.os_uname().sysname == "Windows_NT" then
  opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  opt.shellcmdflag =
    "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit %LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

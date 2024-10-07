-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
  pattern = {
    [".*/Code/.+%.json"] = "jsonc",
    [".*/zed/.+%.json"] = "jsonc",
  },
})

autocmd("FileType", {
  desc = "4-space tab indent filetypes",
  pattern = { "cfg", "fish", "hyprlang", "rasi", "vim", "xf86conf" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

autocmd("TermOpen", {
  desc = "Setup terminal local options",
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
})

autocmd("BufWritePost", {
  desc = "Auto reload tmux config",
  pattern = { "*/.tmux.conf" },
  command = "silent !tmux source-file ~/.tmux.conf",
})

autocmd("BufWritePost", {
  desc = "Auto reload kitty config",
  pattern = { "*/kitty/*" },
  command = "silent !kill -SIGUSR1 $(pgrep kitty)",
})

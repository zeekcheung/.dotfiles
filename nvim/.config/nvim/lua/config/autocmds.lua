-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--- @param name string String: The name of the group
--- @param opts? vim.api.keyset.create_augroup Dict Parameters
--- @return integer # Integer id of the created group.
local function augroup(name, opts)
  opts = opts or { clear = true }
  return vim.api.nvim_create_augroup(name, opts)
end

--- @param event any (string|array) Event(s) that will trigger the handler
--- @param opts vim.api.keyset.create_autocmd.opts
--- @return integer
local function autocmd(event, opts)
  return vim.api.nvim_create_autocmd(event, opts)
end

autocmd("FileType", {
  desc = "4-space indentation for some filetypes",
  group = augroup("4-space-indent"),
  pattern = { "fish", "hyprlang", "rasi" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

autocmd("FileType", {
  desc = "Enable folding for markdown files",
  group = augroup("markdown-fold"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  end,
})

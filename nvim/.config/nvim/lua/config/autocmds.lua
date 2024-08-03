-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd

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

autocmd("FileType", {
  desc = "4-space tab indent filetypes",
  pattern = { "cfg", "fish", "hyprlang", "rasi", "vim", "xf86conf" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

autocmd({ "UIEnter", "ColorScheme" }, {
  desc = "Keep terminal background's color in sync with Neovim's background color",
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

autocmd("UILeave", {
  desc = "Keep terminal background's color in sync with Neovim's background color",
  callback = function()
    io.write("\027]111\027\\")
  end,
})

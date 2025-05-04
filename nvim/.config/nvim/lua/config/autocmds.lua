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

if vim.fn.executable("fcitx5") == 1 then
  local fcitx5_rime_group = augroup("fcitx5-rime")

  ---@type boolean If previous state of fcitx5-rime is chinese mode
  vim.g.rime_prev_chinese = false

  autocmd({ "InsertLeave" }, {
    desc = "Automatically change to english mode of fcitx5-rime",
    group = fcitx5_rime_group,
    callback = function()
      local rime_is_ascii_mode = vim.fn.system(
        "busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode"
      ) == "b true\n"

      if not rime_is_ascii_mode then
        -- Change back to english mode
        vim.fn.system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b 1")
        -- Remember the chinese mode
        vim.g.rime_prev_chinese = true
      else
        -- Remember the english mode
        vim.g.rime_prev_chinese = false
      end
    end,
  })

  autocmd({ "InsertEnter" }, {
    desc = "Automatically change back to chinese mode of fcitx5-rime",
    group = fcitx5_rime_group,
    callback = function()
      if vim.g.rime_prev_chinese then
        -- Change back to chinese mode
        vim.fn.system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b 0")
      end
    end,
  })
end

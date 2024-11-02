-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local fcitx5_rime_group = augroup("fcitx5-rime")

---@type boolean If previous state of fcitx5-rime is chinese mode
vim.g.rime_prev_chinese = false

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  desc = "automatically change to english mode of fcitx5-rime",
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

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  desc = "automatically change back to chinese mode of fcitx5-rime",
  group = fcitx5_rime_group,
  callback = function()
    if vim.g.rime_prev_chinese then
      -- Change back to chinese mode
      vim.fn.system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b 0")
    end
  end,
})

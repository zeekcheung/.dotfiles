-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Better escape
map("i", "jj", "<esc>", { desc = "Better Escape" })

-- Better paste
map("n", "p", '"+p', { desc = "Better paste" })
map("v", "p", "P", { desc = "Better paste" })

-- Misc
map("v", "<C-c>", '"+y', { desc = "Copy selection" })
map("v", "<C-x>", '"+d', { desc = "Cut selection" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
-- map({ 'n', 'v', 'x', 'i' }, '<C-a>', '<esc>ggVG', { desc = 'Select All' })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Window splits
map("n", "|", "<cmd>split<cr>", { desc = "Horizontal Split" })
map("n", "\\", "<cmd>vsplit<cr>", { desc = "Vertical Split" })

-- Buffers
map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader>bo", "<cmd>silent! %bd|e#|bd#<cr>", { desc = "Delete other buffers" })

-- Tabs
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Quit
map({ "n", "v", "x" }, "<leader>qw", "<cmd>exit<cr>", { desc = "Quit current window" })

-- Lsp
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- stylua: ignore start
local smart_resize = require("util.resize").smart_resize
map("n", "<C-Up>", function() smart_resize("up") end, { desc = "Resize window up" })
map("n", "<C-Down>", function() smart_resize("down") end, { desc = "Resize window down" })
map("n", "<C-Left>", function() smart_resize("left") end, { desc = "Resize window left" })
map("n", "<C-Right>", function() smart_resize("right") end, { desc = "Resize window right" })
-- stylua: ignore end

-- stylua: ignore start
local open_terminal = require("util.terminal").open_terminal
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>th", function() open_terminal({ win_opts = { win_config = { split = "below" } } }) end, { desc = "Open terminal horizontally" })
map("n", "<leader>tv", function() open_terminal({ win_opts = { win_config = { split = "right" } } }) end, { desc = "Open terminal vertically" })
map("n", "<leader>tf", function() open_terminal({ win_opts = { win_config = { relative = "editor" } } }) end, { desc = "Open terminal floating" })

vim.api.nvim_create_autocmd("TermEnter", {
  desc = "Set terminal keymaps",
  group = vim.api.nvim_create_augroup("term-keymaps", { clear = true }),
  callback = function()
    map("n", "|", function() open_terminal({ win_opts = { win_config = { split = "below" } } }) end, { desc = "Open terminal horizontally", buffer = 0 })
    map("n", "\\", function() open_terminal({ win_opts = { win_config = { split = "right" } } }) end, { desc = "Open terminal vertically", buffer = 0 })
  end
})
-- stylua: ignore end

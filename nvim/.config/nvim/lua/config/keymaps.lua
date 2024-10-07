-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local smart_resize_window = require("util.resize").smart_resize_window
local open_terminal = require("util.terminal").open_terminal

local map = vim.keymap.set
local del = vim.keymap.del

del("t", "<C-l>")

-- Better escape
map("i", "jj", "<esc>", { desc = "Better Escape" })

-- Better paste
map("v", "p", "pgvy", { desc = "Paste without overriding registers" })

-- Misc
map("v", "<C-c>", '"+y', { desc = "Copy selection" })
map("v", "<C-x>", '"+d', { desc = "Cut selection" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Buffers
map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current buffer" })
map("n", "<leader>bo", "<cmd>silent! %bd|e#|bd#<cr>", { desc = "Delete other buffers" })

-- Tabs
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Quit
map({ "n", "v", "x" }, "<leader>qw", "<cmd>exit<cr>", { desc = "Quit current window" })

-- LSP
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Window splits
map("n", "|", "<cmd>split<cr>", { desc = "Horizontal Split" })
map("n", "\\", "<cmd>vsplit<cr>", { desc = "Vertical Split" })

-- stylua: ignore start

-- Window resizing
map('n', '<C-Left>', function() smart_resize_window 'left' end, { desc = 'Resize window left' })
map('n', '<C-Right>', function() smart_resize_window 'right' end, { desc = 'Resize window right' })
map('n', '<C-Up>', function() smart_resize_window 'up' end, { desc = 'Resize window up' })
map('n', '<C-Down>', function() smart_resize_window 'down' end, { desc = 'Resize window down' })

-- Terminal
map("t", "<esc><esc>", [[<C-\><C-n>]], { desc = "Escape terminal mode" })
map("n", "<leader>th", function() open_terminal("horizontal") end, { desc = "Open horizontal terminal" })
map("n", "<leader>tv", function() open_terminal("vertical") end, { desc = "Open vertical terminal" })
map("n", "<leader>tf", function() open_terminal("float") end, { desc = "Open floating terminal" })

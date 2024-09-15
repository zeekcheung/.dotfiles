-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.transparent = false
vim.g.lazyvim_prettier_needs_config = false

local opt = vim.opt

-- backup
opt.backup = false
opt.swapfile = false

-- appearance
opt.helpheight = 10
opt.shortmess:append("IWs")

-- status
opt.foldcolumn = "0"
-- opt.statusline = " %f %m %=  %Y  %{&fileencoding?&fileencoding:&encoding}  %P  %l:%c "
opt.ruler = false
opt.showcmd = false

-- completion
opt.completeopt = "menu,menuone,noinsert"
opt.pumblend = 0

-- chars
opt.list = false

-- fold
opt.foldtext = "v:lua.require'util.fold'.foldtext()"

-- tabline
opt.tabline = "%!v:lua.require'util.tabline'.tabline()"

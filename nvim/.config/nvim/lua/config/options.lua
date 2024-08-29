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

-- tabline
vim.o.tabline = "%!v:lua.simple_tabline()"

function _G.simple_tabline()
  local has_icons, icons = pcall(require, "mini.icons")
  local s = ""

  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")

    local icon = ""
    if has_icons then
      icon, _, _ = icons.get("file", filename)
    end

    local tab_click = string.format("%%%d@v:lua.switch_tab@", i)
    if i == vim.fn.tabpagenr() then
      -- Highlight for the entire selected tab
      s = s .. string.format("%%#TabLineSel# %s%s %s %%X", tab_click, icon, filename)
    else
      -- Highlight for the entire non-selected tab
      s = s .. string.format("%%#TabLine# %s%s %s %%X", tab_click, icon, filename)
    end
  end

  s = s .. "%#TabLineFill#"

  return s
end

function _G.switch_tab(n)
  vim.cmd("tabnext " .. n)
end

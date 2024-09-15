local M = {}

function M.tabline()
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

    local tab_click = string.format("%%%d@v:lua.require'util.tabline'.switch_tab@", i)
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

function M.switch_tab(n)
  vim.cmd("tabnext " .. n)
end

return M

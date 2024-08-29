local M = {}

---@type table<string, vim.api.keyset.highlight>
M.highlights = {
  -- CmpItemMenu = { bg = "#181825" },
  CmpBorder = { link = "FloatBorder" },
  CmpDocBorder = { link = "CmpBorder" },
  CmpGhostText = { link = "Comment", default = true },
  CursorLineNr = { bg = "NONE" },
  -- Directory = { fg = "#8C96A2" },
  -- FloatBorder = { link = "Comment" },
  FloatBorder = { fg = "#4e4d5d", bg = "NONE" },
  FzfLuaBorder = { link = "FloatBorder" },
  FzfLuaFzfBorder = { link = "FzfLuaBorder" },
  FzfLuaPreviewBorder = { link = "FzfLuaBorder" },
  HoverBorder = { link = "FloatBorder" },
  LspInfoBorder = { link = "FloatBorder" },
  NormalFloat = { link = "Normal" },
  NotifyINFOBorder = { bg = "none" },
  NotifyINFOBorder69 = { bg = "none" },
  NotifyTRACEBorder = { bg = "none" },
  NotifyWARNBorder = { bg = "none" },
  NotifyERRORBorder = { bg = "none" },
  NotifyERRORBorder86 = { bg = "none" },
  NotifyDEBUGBorder = { bg = "none" },
  RainbowDelimiterRed = { fg = "#e67e80" },
  RainbowDelimiterYellow = { fg = "#dbbc7f" },
  RainbowDelimiterGreen = { fg = "#a7c080" },
  RainbowDelimiterBlue = { fg = "#7fbbb3" },
  RainbowDelimiterOrange = { fg = "#e69875" },
  RainbowDelimiterViolet = { fg = "#d699b6" },
  SignatureHelpBorder = { link = "FloatBorder" },
  -- StatusLine = { fg = '#ea9a97', bg = '#eb6f92', blend = vim.g.transparent_background and 0 or 10 },
  -- StatusLineNC = { fg = '#908caa', bg = '#2a273f' },
  TelescopeBorder = { link = "FloatBorder" },
  TelescopeNormal = { bg = "none" },
  TelescopePromptNormal = { bg = "#232136" },
  TelescopeResultsNormal = { fg = "#e0def4" },
  TelescopeSelection = { fg = "#e0def4", bg = "#393552" },
  -- TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },
  WinSeparator = { bg = "NONE", fg = "#4e4d5d" },
}

-- Custom highlight group
function M.draw_my_highlight()
  local ns_id = 0 -- Namespace id, set to 0 for global

  for hl_name, hl_group in pairs(M.highlights) do
    vim.api.nvim_set_hl(ns_id, hl_name, hl_group)
  end
end

---Border with highlight
---@param hl_name string Highlight name
---@return table
function M.border_with_highlight(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

return M

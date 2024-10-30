vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    ---@param name string — Highlight group name
    ---@param val vim.api.keyset.highlight — Highlight definition map
    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    set_hl("NormalFloat", { bg = "NONE" })
    set_hl("FloatBorder", { fg = "#3b4261", bg = "NONE" })
    set_hl("WinSeparator", { link = "FloatBorder" })
    set_hl("FzfLuaNormal", { bg = "NONE" })
    set_hl("FzfLuaFzfNormal", { bg = "NONE" })
    set_hl("FzfLuaBorder", { link = "FloatBorder" })
    set_hl("FzfLuaTitle", { bg = "NONE" })
    set_hl("FzfLuaPreviewTitle", { link = "FzfLuaTitle" })
    set_hl("FzfLuaFilePath", { bg = "NONE" })
    set_hl("FzfLuaFilePart", { bg = "NONE" })
  end,
})

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      -- lualine_bold = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        sidebars = "normal",
        floats = "normal",
      },
    },
  },
}

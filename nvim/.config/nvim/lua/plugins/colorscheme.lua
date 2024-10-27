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
      on_highlights = function(hl)
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { fg = "#3b4261", bg = "NONE" }
        hl.WinSeparator = { link = "FloatBorder" }
        hl.FzfLuaNormal = { bg = "NONE" }
        hl.FzfLuaFzfNormal = { bg = "NONE" }
        hl.FzfLuaBorder = { link = "FloatBorder" }
        hl.FzfLuaTitle = { bg = "NONE" }
        hl.FzfLuaPreviewTitle = { link = "FzfLuaTitle" }
        hl.FzfLuaFilePath = { bg = "NONE" }
        hl.FzfLuaFilePart = { bg = "NONE" }
      end,
    },
  },
}

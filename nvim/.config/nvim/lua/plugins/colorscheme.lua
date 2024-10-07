return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      colorscheme = "tokyonight",
      -- colorscheme = "gruvbox-material",
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = vim.g.transparent,
      styles = {
        keywords = { italic = true },
        sidebars = vim.g.transparent and "transparent" or "normal",
        floats = vim.g.transparent and "transparent" or "normal",
      },
      lualine_bold = true,
      on_colors = function(colors)
        colors.bg_statusline = colors.none
      end,
      on_highlights = function(hl, _)
        -- hl.MatchParen = { link = "LspReferenceText" }
        hl.FloatBorder = { fg = "#3b4261" }
      end,
    },
  },

  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
    opts = {
      transparent_background = vim.g.transparent,
      no_bold = true,
    },
  },

  {
    "sainnhe/gruvbox-material",
    enabled = false,
    config = function()
      -- vim.g.gruvbox_material_foreground = "original"
      -- vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = vim.g.transparent and 1 or 0
      vim.g.gruvbox_material_show_eob = false
      vim.g.gruvbox_material_diagnostic_text_highlight = true
      vim.g.gruvbox_material_diagnostic_line_highlight = true
      vim.g.gruvbox_material_inlay_hints_background = "dimmed"
      vim.g.gruvbox_material_better_performance = true
    end,
  },
}

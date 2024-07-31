return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "rose-pine",
      colorscheme = "tokyonight",
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      dark_variant = "moon",
      dim_inactive_windows = false,
      styles = {
        bold = false,
        transparency = vim.g.transparent,
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = vim.g.transparent,
      styles = {
        sidebars = vim.g.transparent and "transparent" or "normal",
        floats = vim.g.transparent and "transparent" or "normal",
      },
      lualine_bold = true,
      on_colors = function(colors)
        colors.bg_statusline = colors.none
      end,
    },
  },

  {
    "catppuccin/nvim",
    opts = {
      transparent_background = vim.g.transparent,
    },
  },
}

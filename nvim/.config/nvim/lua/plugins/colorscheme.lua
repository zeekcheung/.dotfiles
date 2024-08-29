return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      -- colorscheme = "rose-pine",
      colorscheme = "tokyonight",
      -- colorscheme = "github_dark_dimmed",
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
      -- on_highlights = function(hl, c)
      --   hl.MatchParen = { link = "LspReferenceText" }
      -- end,
    },
  },

  {
    "catppuccin/nvim",
    opts = {
      transparent_background = vim.g.transparent,
      no_bold = true,
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
    "projekt0n/github-nvim-theme",
    config = function()
      vim.g.lazygit_config = false

      require("github-theme").setup({
        options = {
          transparent = vim.g.transparent,
        },
        groups = {
          all = {
            -- NeoTreeDirectoryIcon = { link = "Directory" },
            NeoTreeDirectoryIcon = { fg = "#8C96A2" },
          },
        },
      })
    end,
  },
}

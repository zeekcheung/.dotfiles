return {
  {
    "markdown-preview.nvim",
    enabled = false,
  },

  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        top_down = false,
      },
      win = {
        backdrop = 100,
        width = 0.85,
        height = 0.85,
        border = "rounded",
      },
      terminal = {
        win = {
          wo = {
            winbar = "",
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>th", function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.4 } }) end, desc = "Open terminal horizontally" },
      { "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right", width = 0.4 } }) end, desc = "Open terminal vertically" },
      { "<leader>tf", function() Snacks.terminal(nil, { win = { position = "float" } }) end, desc = "Open terminal floating" },
    },
  },

  {
    "karb94/neoscroll.nvim",
    event = "LazyFile",
    opts = {},
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    keys = {
      { "<C-Up>", "<cmd>SmartResizeUp<cr>", desc = "Resize window up" },
      { "<C-Down>", "<cmd>SmartResizeDown<cr>", desc = "Resize window down" },
      { "<C-Left>", "<cmd>SmartResizeLeft<cr>", desc = "Resize window left" },
      { "<C-Right>", "<cmd>SmartResizeRight<cr>", desc = "Resize window right" },
      { "<C-k>", "<cmd>SmartCursorMoveUp<cr>", desc = "Move cursor up" },
      { "<C-j>", "<cmd>SmartCursorMoveDown<cr>", desc = "Move cursor down" },
      { "<C-h>", "<cmd>SmartCursorMoveLeft<cr>", desc = "Move cursor left" },
      { "<C-l>", "<cmd>SmartCursorMoveRight<cr>", desc = "Move cursor right" },
    },
  },
}

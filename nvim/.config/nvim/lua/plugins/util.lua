return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

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
    },
  },

  {
    "karb94/neoscroll.nvim",
    event = "LazyFile",
    opts = {},
  },
}

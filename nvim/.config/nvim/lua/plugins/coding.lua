return {
  {
    "saghen/blink.cmp",
    opts = {
      windows = {
        autocomplete = {
          border = "rounded",
        },
        documentation = {
          border = "rounded",
        },
        ghost_text = {
          enabled = false,
        },
      },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    event = "LazyFile",
    opts = {
      disable_keymaps = false,
      disable_inline_completion = false,
      log_level = "off",
      keymaps = {
        accept_suggestion = "<C-f>",
        clear_suggestion = "<C-x>",
        accept_word = "<A-f>",
      },
    },
  },
}

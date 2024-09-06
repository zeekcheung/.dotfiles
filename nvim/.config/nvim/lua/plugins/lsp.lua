return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<leader>rn",
        function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
        has = "rename",
      }

      opts.diagnostics.float = { border = "rounded" }
      -- opts.codelens.enabled = true

      -- local border_with_highlight = require("util.highlight").border_with_highlight
      -- local hover_override_config = {
      --   max_width = 75,
      --   max_height = 75,
      --   border = border_with_highlight("HoverBorder"),
      --   silent = true,
      -- }
      -- opts.setup = {
      --   ["*"] = function(server, opts)
      --     vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_override_config)
      --     vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, hover_override_config)
      --   end,
      -- }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      github = {
        download_url_template = "https://gh.zeekcheung.asia/https://github.com/%s/releases/download/%s/%s",
      },
    },
  },
}

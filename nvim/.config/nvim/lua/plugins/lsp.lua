return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      servers = {
        bashls = { mason = false },
        lua_ls = { mason = false },
        jsonls = { mason = false },
        yamlls = { mason = false },
        taplo = { mason = false },
        clangd = { mason = false },
        gopls = { mason = false },
        html = { mason = false },
        cssls = { mason = false },
        volar = { mason = false },
        vtsls = { mason = false },
        ts_ls = { mason = false },
        ruff = { mason = false },
        pyright = { mason = false },
      },
      -- setup = {
      --   ["*"] = function(server, opts)
      --     local border_with_highlight = require("util.highlight").border_with_highlight
      --     local hover_override_config = {
      --       max_width = 75,
      --       max_height = 75,
      --       border = border_with_highlight("HoverBorder"),
      --       silent = true,
      --     }
      --
      --     vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_override_config)
      --     vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, hover_override_config)
      --   end,
      -- },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.max_concurrent_installers = 10

      opts.github = {
        download_url_template = "https://gh.zeekcheung.asia/https://github.com/%s/releases/download/%s/%s",
      }

      opts.ui = {
        border = "rounded",
        keymaps = {
          uninstall_package = "x",
          toggle_help = "?",
        },
      }

      opts.ensure_installed = vim.tbl_filter(function(name)
        return not vim.tbl_contains({ "codelldb" }, name)
      end, opts.ensure_installed)
    end,
  },
}

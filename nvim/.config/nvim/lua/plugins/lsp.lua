---@diagnostic disable: unused-local

-- Check if a language server is running
---@param filter vim.lsp.get_clients.Filter Server name
local function lsp_is_running(filter)
  local attached_servers = vim.lsp.get_clients(filter)
  return #attached_servers > 0
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      codelens = {
        enabled = false,
      },
      servers = {
        lua_ls = { mason = true },
        bashls = { mason = false, filetypes = { "sh", "zsh" } },
        jsonls = { mason = false },
        yamlls = { mason = false },
        taplo = { mason = true, root_dir = require("lspconfig.util").root_pattern("*.toml", ".git") },
        marksman = { mason = true },
        pyright = { mason = false },
        ruff = { mason = false },
        vtsls = { mason = false },
        denols = { mason = false },
        html = { mason = false },
        cssls = { mason = false },
        biome = { mason = false },
        eslint = { mason = false },
        clangd = { mason = false },
        gopls = { mason = false },
        dockerls = { mason = false },
        docker_compose_language_service = { mason = false },
      },
      setup = {
        jsonls = function(server, opts)
          opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        cssls = function(server, opts)
          opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        vtsls = function(server, opts)
          opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        eslint = function(server, opts)
          opts.on_attach = function(client, bufnr)
            -- Disable eslint when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.stop()
            end
          end
        end,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.max_concurrent_installers = 10
      opts.github = {
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
      }
      opts.ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = "󰚌 ",
        },
        keymaps = {
          uninstall_package = "x",
          cancel_installation = "<C-c>",
          toggle_help = "?",
        },
      }
      -- Only installed below tools automatically
      opts.ensure_installed = {
        "stylua",
        -- "shfmt",
        -- "prettierd",
        -- "gofumpt",
        -- "goimports",
        "shellcheck",
        "hadolint",
        -- "markdownlint-cli2",
        -- "markdown-toc",
      }
    end,
  },
}

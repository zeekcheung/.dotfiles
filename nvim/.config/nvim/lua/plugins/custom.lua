-- Check if a language server is running
---@param filter vim.lsp.get_clients.Filter Server name
local function lsp_is_running(filter)
  local attached_servers = vim.lsp.get_clients(filter)
  return #attached_servers > 0
end

-- Set my highlight group
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Set my highlight group",
  pattern = "*",
  callback = function()
    ---@param name string — Highlight group name
    ---@param val vim.api.keyset.highlight — Highlight definition map
    local function set_hl(name, val)
      vim.api.nvim_set_hl(0, name, val)
    end

    set_hl("NormalFloat", { bg = "NONE" })
    set_hl("FloatBorder", { fg = "#3b4261", bg = "NONE" })
    set_hl("WinSeparator", { link = "FloatBorder" })
    set_hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
    set_hl("BlinkCmpDocBorder", { link = "FloatBorder" })
    set_hl("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
  end,
})

return {
  {
    "LazyVim/LazyVim",
    ---@type LazyVimOptions
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
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- mode = "tabs",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = LazyVim.config.icons

      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir({ icon = "󱉭" }),
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, padding = { left = 0, right = 1 } },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = { lsp_doc_border = true },
      views = {
        hover = {
          size = {
            max_width = math.floor(vim.o.columns * 0.8),
            max_height = math.floor(vim.o.lines * 0.8),
          },
          scrollbar = false,
        },
        cmdline_popup = {
          size = { max_width = math.floor(vim.o.columns * 0.8) },
        },
      },
      routes = {
        { filter = { mode = "i" }, view = "mini", opts = { skip = true } },
        { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
        { filter = { event = "notify", find = "man.lua" }, opts = { skip = true } },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      { "<c-f>", mode = { "i", "n", "s" }, false },
      { "<c-b>", mode = { "i", "n", "s" }, false },
    },
  },

  {
    "echasnovski/mini.icons",
    opts = {
      directory = {
        [".vscode"] = { glyph = "󰉋", hl = "MiniIconsYellow" },
        git = { glyph = "󰉋", hl = "MiniIconsOrange" },
        src = { glyph = "󰴉", hl = "MiniIconsGreen" },
        build = { glyph = "󱧼", hl = "MiniIconsGreen" },
        dist = { glyph = "󱧼", hl = "MiniIconsGreen" },
      },
      extension = {
        conf = { glyph = "󰒓", hl = "MiniIconsGrey" },
        ttf = { glyph = "", hl = "MiniIconsRed" },
      },
      file = {
        conf = { glyph = "󰒓", hl = "MiniIconsGrey" },
        config = { glyph = "󰒓", hl = "MiniIconsCyan" },
        profile = { glyph = "󰒓", hl = "MiniIconsGrey" },
        env = { glyph = "󰒓", hl = "MiniIconsYellow" },
        README = { glyph = "󰍔", hl = "MiniIconsBlue" },
        ["README.md"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
        ["README.txt"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
        arch = { glyph = "󰣇", hl = "MiniIconsAzure" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        -- default layout
        layout = {
          preset = "default",
          -- override
          layout = {
            width = 0.80,
            min_width = 70,
            height = 0.80,
            border = "none",
          },
        },
        formatters = {
          file = { filename_first = true },
        },
        sources = {
          explorer = {
            layout = {
              layout = { width = 0.3 },
              -- auto_hide = { "input" },
            },
            win = {
              list = {
                keys = {
                  ["<f2>"] = "explorer_rename",
                  ["<LeftRelease>"] = "confirm",
                },
              },
            },
            exclude = { ".git" },
            include = {
              ".vscode",
              ".node_modules",
              "*.conf*",
              ".local",
              ".gitconfig",
              ".ssh",
              ".profile",
              ".cargo",
              ".zsh*",
              ".bash*",
              "*.env.*",
              ".Xresources",
            },
          },
        },
      },
      notifier = { top_down = false },
      win = {
        backdrop = 100,
        width = 0.85,
        height = 0.85,
        border = "rounded",
      },
      terminal = {
        win = {
          wo = { winbar = "" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<c-p>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>th", function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.5, relative = "editor" } }) end, desc = "Open terminal horizontally" },
      { "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right", width = 0.4, relative = "editor" } }) end,   desc = "Open terminal vertically" },
      { "<leader>tf", function() Snacks.terminal(nil, { win = { position = "float", relative = "editor" } }) end,                desc = "Open terminal floating" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>t", group = "terminal" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- "cpp",
        -- "css",
        -- "desktop",
        -- "ini",
        -- "xresources",
        "powershell",
      },
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        rasi = "/* %s */",
        ini = { "# %s", "; %s" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- LSP keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<F2>", vim.lsp.buf.rename }

      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics, {
        float = { border = "rounded" },
      })

      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
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
      })

      opts.setup = vim.tbl_deep_extend("force", opts.setup, {
        jsonls = function(server, _opts)
          _opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        cssls = function(server, _opts)
          _opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        vtsls = function(server, _opts)
          _opts.on_attach = function(client, bufnr)
            -- Disable lsp formatting when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.server_capabilities.documentFormattingProvider = false
            end
          end
        end,
        eslint = function(server, _opts)
          _opts.on_attach = function(client, bufnr)
            -- Disable eslint when biome is running
            if lsp_is_running({ bufnr = bufnr, name = "biome" }) then
              client.stop()
            end
          end
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = { timeout_ms = 5000 },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        html = { "prettierd", "prettier", stop_after_first = true },
        handlebars = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        ["markdown"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc", stop_after_first = true },
        ["markdown.mdx"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc", stop_after_first = true },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- sh = { "shellcheck" },
        zsh = { "zsh" },
        fish = { "fish" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
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
        -- "shellcheck",
        -- "hadolint",
        -- "markdownlint-cli2",
        -- "markdown-toc",
      }
    end,
  },

  {
    "saghen/blink.cmp",
    opts = {
      cmdline = {
        enabled = false,
        keymap = { preset = "inherit" },
        completion = {
          menu = {
            auto_show = function(_)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          list = {
            selection = { preselect = true, auto_insert = true },
          },
        },
      },
      completion = {
        list = {
          selection = { preselect = true, auto_insert = true },
        },
        menu = {
          border = "none",
        },
        documentation = {
          auto_show = false,
          window = { border = "none" },
        },
      },
      signature = { window = { border = "none" } },
    },
  },

  {
    "markdown-preview.nvim",
    enabled = false,
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

  {
    "stevearc/overseer.nvim",
    init = function()
      Overseer = require("overseer")

      -- Run task and open the window
      function Run_and_open_task(enter)
        Overseer.run_template(nil, function(task)
          if task then
            Overseer.open({ enter = enter })
          end
        end)
      end
    end,
    keys = {
      -- stylua: ignore
      { "<leader>oo", function() Run_and_open_task(true) end, desc = "Run and open task" },
    },
  },

  {
    "luozhiya/fittencode.nvim",
    opts = {},
    dependencies = {
      {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
          opts.sections.lualine_x[#opts.sections.lualine_x + 1] = {
            function()
              local emoji = { "🚫", "⏸️", "⌛️", "⚠️", " ", "✅" }
              return " " .. emoji[require("fittencode").get_current_status()]
            end,
          }
        end,
      },
    },
  },
}

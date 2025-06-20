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
      lualine_bold = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        sidebars = "normal",
        floats = "normal",
      },
      on_colors = function(colors)
        colors.fg_gutter = "#505878"
      end,
      ------@diagnostic disable-next-line: unused-local
      ---on_highlights = function(hl, colors)
      ---  hl["@keyword"] = { fg = "#eb6f92" }
      ---end,
    },
  },

  {
    "catppuccin/nvim",
    opts = {
      term_colors = true,
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      dark_variant = "moon",
      styles = {
        bold = true,
        italic = false,
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "",
            text_align = "center",
            separator = true,
          },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons

      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      local disabled_filetypes =
        { "snacks_dashboard", "snacks_layout_box", "snacks_picker_list", "snacks_picker_input" }

      opts.options.disabled_filetypes = {
        statusline = disabled_filetypes,
        winbar = disabled_filetypes,
      }

      opts.sections.lualine_c = {
        vim.tbl_deep_extend("force", LazyVim.lualine.root_dir({ icon = "󱉭" }), {
          padding = { left = 1 },
        }),
        { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path(), padding = { left = 0 } },
        -- { "filename", padding = { left = 0 } },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          on_click = function()
            vim.cmd("Trouble diagnostics")
          end,
        },
      }

      opts.sections.lualine_x = {
        {
          "diff",
          symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
            end
          end,
          on_click = function()
            Snacks.picker.git_status()
          end,
        },
        {
          "lsp_status",
          symbols = { spinner = "", done = "" },
          on_click = function()
            vim.cmd("LspInfo")
          end,
        },
        -- stylua: ignore
        { function() return vim.bo.ft end },
        { "encoding" },
        { "fileformat", padding = { left = 1, right = 2 } },
      }
      opts.sections.lualine_y = { "progress" }
      opts.sections.lualine_z = { "location" }

      opts.winbar = {
        lualine_c = {
          { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          { "filename", padding = { left = 0 } },
        },
      }

      opts.inactive_winbar = opts.winbar
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
    "nvim-mini/mini.icons",
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
        db = {
          sqlite3_path = vim.fn.has("win32") == 1
              and "~/AppData/Local/Microsoft/WinGet/Packages/SQLite.SQLite_Microsoft.Winget.Source_8wekyb3d8bbwe/sqlite3.exe"
            or nil,
        },
        -- default layout
        layout = {
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= (vim.o.lines * 2.67) and "default" or "vertical"
          end,
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
        win = {
          input = {
            keys = {
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            },
          },
        },
        sources = {
          files = { hidden = true },
          explorer = {
            layout = {
              layout = { width = 0.3 },
              -- auto_hide = { "input" },
              -- preview = "main",
            },
            win = {
              list = {
                keys = {
                  ["<f2>"] = "explorer_rename",
                  ["<LeftRelease>"] = "confirm",
                  ["<C-l>"] = { "<cmd>wincmd 2w<CR>", expr = true },
                },
              },
            },
            hidden = true,
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
          projects = {
            projects = { vim.fn.expand("~/OneDrive/Obsidian") },
          },
        },
      },
      notifier = { top_down = false },
      win = {
        width = 0.85,
        height = 0.85,
        -- border = "rounded",
        -- backdrop = 100,
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
      { "<leader>th", function() Snacks.terminal(vim.g.termcmd, { win = { position = "bottom", height = 0.5, relative = "editor" } }) end, desc = "Open terminal horizontally" },
      { "<leader>tv", function() Snacks.terminal(vim.g.termcmd, { win = { position = "right", width = 0.4, relative = "editor" } }) end,   desc = "Open terminal vertically" },
      { "<leader>tf", function() Snacks.terminal(vim.g.termcmd, { win = { position = "float", relative = "editor" } }) end,          desc = "Open terminal floating" },
      { "<leader>tt", function() vim.cmd("term ".. vim.g.termcmd) end,  desc = "Open terminal in new buffer" }
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
        -- "powershell",
        -- "tmux",
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
    opts = {
      diagnostics = {
        float = { border = "rounded" },
      },
      servers = {
        ["*"] = {
          keys = {
            { "<F2>", vim.lsp.buf.rename },
          },
        },
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
        eslint = { mason = false },
        clangd = { mason = false },
        gopls = { mason = false },
        dockerls = { mason = false },
        docker_compose_language_service = { mason = false },
        powershell_es = {
          mason = false,
          enabled = vim.fn.executable("pwsh") == 1 or vim.fn.executable("powershell") == 1,
          settings = {
            -- check vscode settings for powershell_es
            codeFormatting = {
              addWhitespaceAroundPipe = true,
              alignPropertyValuePairs = true,
              autoCorrectAliases = false,
              avoidSemicolonsAsLineTerminators = false,
              ignoreOneLineBlock = true,
              newLineAfterCloseBrace = true,
              newLineAfterOpenBrace = true,
              openBraceOnSameLine = true,
              pipelineIndentationStyle = "NoIndentation",
              preset = "Custom",
              trimWhitespaceAroundPipe = false,
              useConstantStrings = false,
              useCorrectCasing = false,
              whitespaceAfterSeparator = true,
              whitespaceAroundOperator = true,
              whitespaceBeforeOpenBrace = true,
              whitespaceBeforeOpenParen = true,
              whitespaceBetweenParameters = false,
              whitespaceInsideBrace = true,
            },
          },
        },
        nushell = { mason = false, enabled = vim.fn.executable("nu") == 1 },
      },
    },
    setup = {},
  },

  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = { timeout_ms = 5000 },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        ["c++"] = { "clang-format" },
        xml = { "xmlformatter" },
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
        -- download_url_template = "https://github.com/%s/releases/download/%s/%s",
        download_url_template = "https://gh-proxy.com/github.com/%s/releases/download/%s/%s",
      }
      opts.ui = {
        -- border = "rounded",
        -- backdrop = 100,
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
        -- "clang-format",
        -- "gofumpt",
        -- "goimports",
        -- "shellcheck",
        -- "xmlformatter"
        -- "hadolint",
        -- "markdownlint-cli2",
        -- "markdown-toc",
        -- "powershell"
      }
    end,
  },

  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      cmdline = {
        enabled = true,
        keymap = {
          -- preset = "inherit",
          ["<CR>"] = {},
          ["<Tab>"] = { "insert_next" },
          ["<S-Tab>"] = { "insert_prev" },
        },
        completion = {
          menu = {
            auto_show = function(_)
              return true
              -- return vim.fn.getcmdtype() == ":"
            end,
          },
          list = {
            selection = { preselect = false, auto_insert = true },
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
        ghost_text = { enabled = false },
      },
      signature = { window = { border = "none" } },
    },
  },

  { "markdown-preview.nvim", enabled = false },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      checkbox = {
        enabled = true,
        unchecked = { icon = " " },
        checked = { icon = "󰄳 " },
      },
      html = { comment = { conceal = false } },
    },
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      default_amount = 1,
    },
    keys = {
      { "<C-h>", "<cmd>SmartCursorMoveLeft<cr>", desc = "Move cursor left" },
      { "<C-j>", "<cmd>SmartCursorMoveDown<cr>", desc = "Move cursor down" },
      { "<C-k>", "<cmd>SmartCursorMoveUp<cr>", desc = "Move cursor up" },
      { "<C-l>", "<cmd>SmartCursorMoveRight<cr>", desc = "Move cursor right" },
      { "<C-Up>", "<cmd>SmartResizeUp<cr>", desc = "Resize window up" },
      { "<C-Down>", "<cmd>SmartResizeDown<cr>", desc = "Resize window down" },
      { "<C-Left>", "<cmd>SmartResizeLeft<cr>", desc = "Resize window left" },
      { "<C-Right>", "<cmd>SmartResizeRight<cr>", desc = "Resize window right" },
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
    opts = {
      delay_completion = {
        delaytime = 250,
      },
    },
    specs = {
      {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function(_, opts)
          table.insert(opts.sections.lualine_x, #opts.sections.lualine_x, {
            function()
              local emoji = { "🚫", "⏸️", "⌛️", "⚠️", " ", "✅" }
              return " " .. emoji[require("fittencode").get_current_status()]
            end,
          })
        end,
      },
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    cmd = "Obsidian",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "Obsidian",
          path = "~/OneDrive/Obsidian",
        },
      },
      notes_subdr = "02-Notes",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "journal-template.md",
        default_tags = {},
        workdays_only = false,
      },
      completion = {
        blink = true,
        min_chars = 1,
      },
      new_notes_location = "current_dir",
      preferred_link_style = "wiki",
      frontmatter = {
        enabled = true,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      picker = {
        name = "snacks.pick",
      },
      attachments = {
        folder = "attachments",
      },
      footer = {
        enabled = false,
      },
      legacy_commands = false,
    },
  },
}

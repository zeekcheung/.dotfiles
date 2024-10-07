return {
  {
    "rcarriga/nvim-notify",
    enabled = true,
    opts = {
      top_down = false,
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
    opts = {
      options = {
        mode = "tabs",
        diagnostics = false,
        show_duplicate_prefix = false,
      },
      highlights = {
        buffer_selected = { italic = false, bold = false },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function(_, opts)
      -- local theme = require("lualine.themes.auto")
      -- theme.normal.c = require("util.highlight").highlights.LualineNormalC
      -- opts.options.theme = theme

      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      opts.sections.lualine_a = {}
      opts.sections.lualine_b = {}
      opts.sections.lualine_y = {}
      opts.sections.lualine_z = {}

      opts.sections.lualine_c = {
        "mode",
        "branch",
        "%f %m",
        -- stylua: ignore
        { "diff", on_click = function() vim.cmd("FzfLua git_status") end },
        -- stylua: ignore
        { "diagnostics", on_click = function() vim.cmd("Trouble diagnostics") end, },
        -- "filename",
      }
      opts.sections.lualine_x = {
        -- stylua: ignore
        { "encoding", fmt = function(str) return string.upper(str) end, },
        -- { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "LF" } },
        { "fileformat" },
        "%Y",
        "progress",
        "location",
      }

      --   opts.sections.lualine_b[1] = { "branch", icon = "" }
      --   opts.sections.lualine_c[1] = LazyVim.lualine.root_dir({ icon = "󱉭" })
      --
      --   opts.sections.lualine_c[4] = { "filename", separator = "", padding = { left = 0, right = 0 } }
      --   opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path(), padding = { left = 0, right = 0 } }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
  },

  {
    "folke/noice.nvim",
    enabled = true,
    opts = {
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
      lsp = {
        hover = {
          -- enabled = false,
          silent = true,
        },
        signature = {
          -- enabled = false,
        },
      },
      views = {
        mini = {
          win_options = {
            winblend = vim.g.transparent and 0 or 1,
          },
        },
        hover = {
          size = {
            max_width = math.floor(vim.o.columns * 0.75),
            max_height = math.floor(vim.o.lines * 0.75),
          },
        },
      },
      routes = {
        { filter = { event = "notify", find = "man%.lua" }, opts = { skip = true } },
        { view = "notify", filter = { event = "msg_showmode" } },
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
      extension = {
        conf = { glyph = "󰒓", hl = "MiniIconsGrey" },
        log = { glyph = "󰌪", hl = "MiniIconsGreen" },
        mdx = { glyph = "󰍔", hl = "MiniIconsAzure" },
      },
      file = {
        [".bash_login"] = { glyph = "", hl = "MiniIconsGreen" },
        [".bash_profile"] = { glyph = "", hl = "MiniIconsGreen" },
        [".bashenv"] = { glyph = "", hl = "MiniIconsGreen" },
        [".bashrc"] = { glyph = "", hl = "MiniIconsGreen" },
        [".env"] = { glyph = "", hl = "MiniIconsYellow" },
        [".env.development"] = { glyph = "", hl = "MiniIconsYellow" },
        [".env.example"] = { glyph = "", hl = "MiniIconsYellow" },
        [".env.production"] = { glyph = "", hl = "MiniIconsYellow" },
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsPurple" },
        [".gitconfig"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.json"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.js"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.toml"] = { glyph = "", hl = "MiniIconsPurple" },
        [".shellcheckrc"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        [".zshrc"] = { glyph = "", hl = "MiniIconsGreen" },
        ["arch"] = { glyph = "󰣇", hl = "MiniIconsBlue" },
        ["fedora"] = { glyph = "󰣛", hl = "MiniIconsBlue" },
        ["ubuntu"] = { glyph = "󰕈", hl = "MiniIconsOrange" },
        ["debian"] = { glyph = "󰣚", hl = "MiniIconsRed" },
        ["eslint.config.js"] = { glyph = "", hl = "MiniIconsPurple" },
        ["eslint.config.ts"] = { glyph = "", hl = "MiniIconsPurple" },
        ["hypridle.conf"] = { glyph = "", hl = "MiniIconsCyan" },
        ["hyprland.conf"] = { glyph = "", hl = "MiniIconsCyan" },
        ["hyprlock.conf"] = { glyph = "", hl = "MiniIconsCyan" },
        ["hyprpaper.conf"] = { glyph = "", hl = "MiniIconsCyan" },
        ["hyprshade.toml"] = { glyph = "", hl = "MiniIconsCyan" },
        ["LICENSE"] = { glyph = "", hl = "MiniIconsYellow" },
        ["LICENSE.md"] = { glyph = "", hl = "MiniIconsYellow" },
        ["LICENSE.txt"] = { glyph = "", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["README"] = { glyph = "", hl = "MiniIconsAzure" },
        ["README.md"] = { glyph = "", hl = "MiniIconsAzure" },
        ["README.txt"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        css = { glyph = "", hl = "MiniIconsAzure" },
        fish = { glyph = "", hl = "MiniIconsGreen" },
        go = { glyph = "", hl = "MiniIconsAzure" },
        godoc = { glyph = "", hl = "MiniIconsOrange" },
        gomod = { glyph = "", hl = "MiniIconsAzure" },
        gosum = { glyph = "", hl = "MiniIconsCyan" },
        gotmpl = { glyph = "", hl = "MiniIconsGrey" },
        gowork = { glyph = "", hl = "MiniIconsPurple" },
        html = { glyph = "", hl = "MiniIconsOrange" },
        javascript = { glyph = "", hl = "MiniIconsYellow" },
        ["javascript.glimmer"] = { glyph = "", hl = "MiniIconsRed" },
        less = { glyph = "", hl = "MiniIconsPurple" },
        jq = { glyph = "", hl = "MiniIconsBlue" },
        json = { glyph = "", hl = "MiniIconsYellow" },
        json5 = { glyph = "", hl = "MiniIconsOrange" },
        jsonc = { glyph = "", hl = "MiniIconsYellow" },
        jsonl = { glyph = "", hl = "MiniIconsYellow" },
        md = { glyph = "", hl = "MiniIconsAzure" },
        php = { glyph = "", hl = "MiniIconsPurple" },
        phtml = { glyph = "", hl = "MiniIconsOrange" },
        python = { glyph = "󰌠", hl = "MiniIconsAzure" },
        python2 = { glyph = "󰌠", hl = "MiniIconsAzure" },
        sass = { glyph = "", hl = "MiniIconsRed" },
        scss = { glyph = "", hl = "MiniIconsRed" },
        toml = { glyph = "", hl = "MiniIconsOrange" },
        typescript = { glyph = "", hl = "MiniIconsAzure" },
      },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      -- stylua: ignore
      local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
      ]]
      logo = string.rep("\n", 3) .. logo .. "\n"
      opts.config.header = vim.split(logo, "\n")

      table.remove(opts.config.center, 2)
      table.remove(opts.config.center, 4)

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      opts.hide = {
        statusline = false,
        tabline = true,
        winbar = true,
      }
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    event = "LazyFile",
    config = function()
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterGreen",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterViolet",
        },
      }
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    ft = { "markdown", "rmd", "vimwiki", "org", "norg" },
    opts = {
      file_types = { "markdown", "rmd", "vimwiki", "org", "norg" },
      sign = { enabled = false },
      overrides = {
        buftype = {
          nofile = {
            code = {},
          },
        },
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    cond = not vim.g.neovide,
    opts = {},
  },
}

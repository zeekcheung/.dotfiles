return {
  {
    "nvimdev/dashboard-nvim",
    init = function()
      vim.opt.ruler = false
      vim.opt.showcmd = false
    end,
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

      -- padding-top: 2 * \n
      logo = string.rep("\n", 3) .. logo .. "\n"

      opts.hide = {
        statusline = false,
        tabline = true,
        winbar = true,
      }

      opts.config.header = vim.split(logo, "\n")

      -- stylua: ignore
      opts.config.center = {
        { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
        -- { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
        { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
        -- { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
        { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
        { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
        { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
        { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
        { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end
    end,
  },

  {
    "folke/noice.nvim",
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
      },
    },
    keys = {
      { "<c-f>", mode = { "i", "n", "s" }, false },
      { "<c-b>", mode = { "i", "n", "s" }, false },
    },
  },

  {
    "rcarriga/nvim-notify",
    enabled = false,
    opts = {
      top_down = false,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    optional = true,
    opts = function(_, opts)
      local theme = require("lualine.themes.auto")
      theme.normal.c = { fg = "#768390" }
      opts.options.theme = theme

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
        "encoding",
        "fileformat",
        "%Y",
        "progress",
        "location",
      }

      -- opts.sections.lualine_b[1] = { "branch", icon = "" }
      -- opts.sections.lualine_c[1] = LazyVim.lualine.root_dir({ icon = "󱉭" })
      --
      -- -- opts.sections.lualine_c[4] = { "filename", separator = "", padding = { left = 0, right = 0 } }
      -- opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path(), padding = { left = 0, right = 0 } }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    enabled = true,
    opts = {
      options = {
        mode = "tabs",
        diagnostics = false,
        show_duplicate_prefix = false,
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
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
}

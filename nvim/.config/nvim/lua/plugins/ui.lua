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
          silent = true,
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
    opts = {
      top_down = false,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sections.lualine_b[1] = { "branch", icon = "" }
      opts.sections.lualine_c[1] = LazyVim.lualine.root_dir({ icon = "󱉭" })

      -- opts.sections.lualine_c[4] = { "filename", separator = "", padding = { left = 0, right = 0 } }
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path(), padding = { left = 0, right = 0 } }
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
}

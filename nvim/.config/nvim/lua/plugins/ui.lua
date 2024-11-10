return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
      },
    },
  },

  {
    "folke/noice.nvim",
    keys = {
      { "<c-f>", false },
      { "<c-b>", false },
    },
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      views = {
        hover = {
          size = {
            max_width = math.floor(vim.o.columns * 0.8),
            max_height = math.floor(vim.o.lines * 0.8),
          },
          scrollbar = false,
        },
      },
      routes = {
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
  },

  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
         ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
         ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
         ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
         ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
         ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
         ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
      ]]

      logo = string.rep("\n", 2) .. logo .. ""

      opts.config.header = vim.split(logo, "\n")
    end,
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
    "echasnovski/mini.icons",
    opts = {
      directory = {
        [".vscode"] = { glyph = "󰉋", hl = "MiniIconsYellow" },
        git = { glyph = "󰉋", hl = "MiniIconsOrange" },
        src = { glyph = "󰴉", hl = "MiniIconsGreen" },
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
}

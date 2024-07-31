return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- keys = {
    --   { "<leader>fe", false },
    --   { "<leader>fE", false },
    --   {
    --     "<leader>fe",
    --     function()
    --       require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
    --     end,
    --     desc = "Explorer NeoTree (cwd)",
    --   },
    --   {
    --     "<leader>E",
    --     function()
    --       require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
    --     end,
    --     desc = "Explorer NeoTree (Root Dir)",
    --   },
    -- },
    opts = {
      enable_diagnostics = false,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      default_component_configs = {
        indent = {
          with_expanders = false,
        },
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
          ["s"] = "none", -- disable default mappings
          ["<2-LeftMouse>"] = "none",
          ["<leftrelease>"] = "open",
          ["za"] = "toggle_node",
          ["P"] = {
            "toggle_preview",
            config = { use_float = true, use_image_nvim = true },
          },
        },
      },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = false },
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {},
          always_show = {
            ".config",
            ".local",
            ".bashrc",
            ".bash_profile",
            ".tmux.conf",
            ".vimrc",
            ".zshenv",
            ".zshrc",
          },
          never_show = {},
        },
      },
      buffers = {
        window = {
          mappings = {
            ["d"] = "buffer_delete",
          },
        },
      },

      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "no"
            vim.opt_local.statuscolumn = ""
          end,
        },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        backdrop = 100,
        preview = {
          layout = "horizontal",
          scrollbar = false,
        },
      },
      defaults = {
        formatter = {
          "path.filename_first",
        },
      },
    },
    -- keys = {
    --   { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    --   { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    --   -- find
    --   { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    --   { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    --   { "<leader>fr", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    --   -- search
    --   { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    --   { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    --   { "<leader>sW", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
    --   { "<leader>sw", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
    --   { "<leader>sw", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
    --   { "<leader>sW", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
    --   { "<leader>uC", LazyVim.pick("colorschemes"), desc = "Colorscheme with Preview" },
    -- },
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
}

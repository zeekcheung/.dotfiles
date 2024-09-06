return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      { "echasnovski/mini.icons" },
    },
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
        icon = {
          -- folder_closed = "",
          -- folder_open = "",
          -- folder_empty = "",
          -- folder_empty_open = "",
          default = "󰈔",
          provider = function(icon, node) -- setup a custom icon provider
            local text, hl
            local mini_icons = require("mini.icons")
            if node.type == "file" then -- if it's a file, set the text/hl
              text, hl = mini_icons.get("file", node.name)
            elseif node.type == "directory" then -- get directory icons
              text, hl = mini_icons.get("directory", node.name)
              -- only set the icon text if it is not expanded
              if node:is_expanded() then
                text = nil
              end
            elseif node.type == "symbol" then
              local kind = vim.tbl_get(node, "extra", "kind", "name")
              if kind then
                text, hl = mini_icons.get("lsp", kind)
              end
            end

            -- set the icon text/highlight only if it exists
            if text then
              icon.text = text
            end
            if hl then
              icon.highlight = hl
            end
          end,
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
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {},
          always_show = {
            ".bashrc",
            ".bash_profile",
            ".config",
            ".editorconfig",
            ".gitignore",
            ".local",
            ".prettierrc",
            ".tmux.conf",
            ".vimrc",
            ".zshenv",
            ".zshrc",
          },
          never_show = {
            ".git",
          },
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
          -- layout = "horizontal",
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

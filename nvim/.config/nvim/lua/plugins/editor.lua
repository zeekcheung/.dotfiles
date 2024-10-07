return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "echasnovski/mini.icons" },
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
        {
          event = "after_render",
          handler = function()
            if vim.tbl_contains({ "gruvbox-material" }, vim.g.colors_name) then
              local ns_id = 0
              vim.api.nvim_set_hl(ns_id, "NeoTreeNormal", { link = "Normal", force = true })
              vim.api.nvim_set_hl(ns_id, "NeoTreeEndOfBuffer", { link = "Normal", force = true })
            end
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
          scrollbar = false,
        },
      },
      defaults = {
        formatter = {
          "path.filename_first",
        },
      },
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
}

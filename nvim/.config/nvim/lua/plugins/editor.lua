return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["s"] = "none",
          ["<space>"] = "none",
          ["<leftrelease>"] = "open",
          ["gh"] = "toggle_hidden",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
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
        kind_icon = {
          provider = function(icon, node)
            local mini_icons = require("mini.icons")
            icon.text, icon.highlight = mini_icons.get("lsp", node.extra.kind.name)
          end,
        },
      },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        filtered_items = {
          visiable = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true,
          always_show = {
            ".config",
            ".local",
            ".cargo",
            ".fzfrc",
            ".gitconfig",
            ".gtkrc-2.0",
            ".tmux.conf",
            ".Xresources",
            ".vscode",
          },
          always_show_by_pattern = { -- uses glob style patterns
            ".zsh*",
          },
          never_show = {
            ".git",
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
      },
      defaults = {
        formatter = "path.filename_first",
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

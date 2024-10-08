local border_with_highlight = require("util.highlight").border_with_highlight

return {
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.experimental.ghost_text = false

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.mapping["<C-F>"] = nil
      opts.mapping["<C-B>"] = nil

      opts.window = {
        completion = {
          side_padding = 1,
          border = border_with_highlight("CmpBorder"),
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          scrollbar = false,
        },
        documentation = {
          border = border_with_highlight("CmpDocBorder"),
          winhighlight = "Normal:CmpDoc",
        },
        -- documentation = cmp.config.disable,
      }
    end,
  },

  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require("cmp")

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },

  {
    "supermaven-inc/supermaven-nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<C-f>",
        clear_suggestion = "<C-x>",
        accept_word = "<A-f>",
      },
      ignore_filetypes = {},
      log_level = "off", -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
    },
  },

  {
    "Exafunction/codeium.vim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      vim.g.codeium_idle_delay = 250
      vim.g.codeium_render = true

      -- stylua: ignore start
      local map = vim.keymap.set
      map("i", "<C-f>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
      map("i", "<c-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
      map("i", "<c-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
      map("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<leader>rn",
        function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
        has = "rename",
      }

      opts.diagnostics = {
        float = {
          border = "rounded",
        },
      }

      -- opts.setup = {
      --   ["*"] = function(server, opts)
      --     vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --       max_width = 75,
      --       max_height = 75,
      --     })
      --   end,
      -- }
    end,
  },
}

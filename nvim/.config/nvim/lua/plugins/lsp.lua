return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ["*"] = function(server, opts)
          -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          --   max_width = 75,
          --   max_height = 75,
          -- })
        end,
      },
    },
  },
}

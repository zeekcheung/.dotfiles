return {
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        stop_after_first = true,
      },
      formatters_by_ft = {
        javascript = { "biome", "prettier" },
        typescript = { "biome", "prettier" },
        javascriptreact = { "biome", "prettier" },
        typescriptreact = { "biome", "prettier" },
        html = { "biome", "prettier" },
        css = { "biome", "prettier" },
        scss = { "biome", "prettier" },
        less = { "biome", "prettier" },
        vue = { "biome", "prettier" },
        graphql = { "biome", "prettier" },
        handlebars = { "biome", "prettier" },
        json = { "biome", "prettier" },
        jsonc = { "biome", "prettier" },
        yaml = { "prettier" },
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
      formatters = {
        prettier = {
          prepend_args = function()
            local default_args = {}
            if vim.bo.ft == "jsonc" then
              default_args = vim.tbl_extend("force", default_args, { "--parser", "json" })
            end
            return default_args
          end,
        },
      },
    },
  },
}

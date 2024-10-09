return {
  {
    "stevearc/conform.nvim",
    opts = {
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

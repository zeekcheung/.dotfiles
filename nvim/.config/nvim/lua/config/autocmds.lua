-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

LazyVim.on_very_lazy(function()
  vim.filetype.add({
    filename = {
      ["Settings.XamlStyler"] = "json",
    },
    pattern = {
      [".+%.[a]xaml"] = "xml",
    },
  })
end)

vim.api.nvim_create_autocmd("FileType", {
  desc = "4-space indentation for some filetypes",
  group = vim.api.nvim_create_augroup("4-space-indent", { clear = true }),
  pattern = { "c", "cpp", "cs", "go", "rust", "python", "fish", "hyprlang", "rasi" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Markdown related options",
  group = vim.api.nvim_create_augroup("markdown-fold", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt_local.commentstring = "<!-- %s -->"
  end,
})

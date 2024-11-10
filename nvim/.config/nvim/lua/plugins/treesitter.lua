return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cpp",
        "css",
        "desktop",
        "ini",
        "xresources",
      },
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        rasi = "/* %s */",
        ini = { "# %s", "; %s" },
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "javascript", "html",
        "python", "markdown", "rust",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },
}

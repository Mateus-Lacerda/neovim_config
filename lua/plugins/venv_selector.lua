return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("venv-selector").setup({
       auto_select = true,
       name = { ".venv" },
    })
  end,
  -- Opcional: ativa ao entrar em um buffer Python
  event = "BufRead",
}

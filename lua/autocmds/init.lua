-- My tabs preferences
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- My line numbers preferences
vim.cmd[[colorscheme tokyonight-night]]

-- Disable copilot by default
vim.cmd("Copilot disable")

-- Fold method
vim.cmd("set foldmethod=manual")

-- init.lua
vim.o.updatetime = 250

 -- Mantém o tempo pra disparar o CursorHold
local function is_hover_window_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
    if buf_ft == 'lspinfo' or vim.api.nvim_win_get_config(win).relative ~= '' then
      return true -- Tem uma janela flutuante (como hover) aberta
    end
  end
  return false
end

-- Autocomando pra mostrar diagnostics apenas se não tiver hover aberto
vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  callback = function()
    if not is_hover_window_open() then
      vim.diagnostic.open_float(nil, { focus = false })
    end
  end,
})

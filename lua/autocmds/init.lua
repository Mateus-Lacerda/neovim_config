-- My tabs preferences
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Colorscheme
require("catppuccin").setup({ transparent_background = true })
vim.cmd [[colorscheme catppuccin]]

-- -- Disable copilot by default
-- vim.cmd("Copilot disable")

-- Fold method
vim.cmd("set foldmethod=manual")

-- init.lua
vim.o.updatetime = 150

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
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
        if not is_hover_window_open() then
            vim.diagnostic.open_float(nil, { focus = false })
        end
    end,
})

-- Autocomando pra usar ruff em arquivos python
require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    },
    formatters = {
        ruff_organize_imports = {
            command = "ruff",
            args = { "check", "--force-exclude", "--select=I", "--fix", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
        },
        ruff_fix = {
            command = "ruff",
            args = { "check", "--force-exclude", "--fix", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
            exit_codes = { 0, 1 },
        },
        ruff_format = {
            command = "ruff",
            args = { "format", "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
        },
    },
})

-- Habilita gq em seleções (range)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
})


-- Desabilita o copilot
-- vim.cmd("Copilot disable")

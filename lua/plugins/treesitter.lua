return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            local install = require("nvim-treesitter.install")
            install.prefer_git = true

            -- Lista de filetypes que NÃO devem carregar Treesitter
            local skip_filetypes = {
                "oil",
                "oilpreview",
                "fidget",
                "lazy",
                "mason",
                "notify",
                "prompt",
                "TelescopePrompt",
                "NvimTree",
            }

            local function should_skip(ft)
                for _, skip in ipairs(skip_filetypes) do
                    if ft == skip then return true end
                end
                return false
            end

            -- 1. Auto Install (apenas para arquivos reais)
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ft = vim.bo[args.buf].filetype
                    if should_skip(ft) or ft == "" then return end

                    local lang = vim.treesitter.language.get_lang(ft) or ft
                    if lang then
                        local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0
                        if not is_installed then
                            vim.cmd("TSInstall " .. lang)
                        end
                    end
                end,
            })

            -- 2. Habilitar Highlighting (com filtros de performance e utilitários)
            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                callback = function()
                    local ft = vim.bo.filetype

                    -- Não tenta carregar se estiver na blacklist ou for um buffer inválido
                    if should_skip(ft) or ft == "" or vim.bo.buftype ~= "" then
                        return
                    end

                    -- Só tenta habilitar se houver um parser instalado
                    local has_parser = pcall(vim.treesitter.get_parser, 0, ft)
                    if has_parser then
                        vim.treesitter.start()
                    end
                end,
            })
        end,
    },
}

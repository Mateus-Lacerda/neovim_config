return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            -- Na main, o 'setup' pode não existir mais no mesmo lugar ou estar quebrado.
            -- Vamos usar a API de instalação e configuração diretamente.

            local install = require("nvim-treesitter.install")

            -- Configuração de Auto Install (o que você queria da master)
            install.prefer_git = true -- Geralmente melhor no Arch/macOS

            -- Emulação do auto_install da master
            -- A branch main está movendo isso para o core do Neovim,
            -- mas você pode forçar o comportamento aqui:
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf]
                    .filetype
                    if lang then
                        -- Verifica se o parser já está instalado, se não, instala.
                        local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0
                        if not is_installed then
                            vim.cmd("TSInstall " .. lang)
                        end
                    end
                end,
            })

            -- Habilitar Highlighting "na mão" já que o módulo de config sumiu
            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                callback = function()
                    local lang = vim.bo.filetype
                    -- Só tenta habilitar se houver um parser instalado para a linguagem
                    local has_parser = pcall(vim.treesitter.get_parser, 0, lang)
                    if has_parser then
                        vim.treesitter.start()
                    end
                end,
            })
        end,
    },
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            vim.filetype.add({
                filename = {
                    ["resolv.conf"] = "conf",
                },
            })

            local install = require("nvim-treesitter.install")
            install.prefer_git = true

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
                "TelescopeResults",
            }

            local function should_skip(ft)
                for _, skip in ipairs(skip_filetypes) do
                    if ft == skip then
                        return true
                    end
                end
                return false
            end

            -- auto install só quando existir linguagem/parsers válidos
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype
                    if should_skip(ft) or ft == "" or vim.bo[buf].buftype ~= "" then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(ft)
                    if not lang then
                        return
                    end

                    local ok = pcall(vim.treesitter.language.add, lang)
                    if ok then
                        return -- já existe parser carregável
                    end

                    local has_parser =
                        #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0

                    if not has_parser then
                        pcall(vim.cmd, "TSInstall " .. lang)
                    end
                end,
            })

            -- start só se o parser existir; senão deixa syntax fallback agir
            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype

                    if should_skip(ft) or ft == "" or vim.bo[buf].buftype ~= "" then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(ft)
                    if not lang then
                        return
                    end

                    local ok = pcall(vim.treesitter.language.add, lang)
                    if not ok then
                        return
                    end

                    pcall(vim.treesitter.start, buf, lang)
                end,
            })
        end,
    },
}

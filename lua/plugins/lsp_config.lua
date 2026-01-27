return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        { "j-hui/fidget.nvim",       opts = {} },
    },

    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                local builtin = require("telescope.builtin")
                map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
                map("gr", builtin.lsp_references, "[G]oto [R]eferences")
                map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight",
                        { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

        local function should_use_ty()
            local root_files = vim.fs.find({ 'pyproject.toml' }, { upward = true, path = vim.fn.getcwd() })
            if #root_files == 0 then return false end
            local file = io.open(root_files[1], "r")
            if not file then return false end
            local content = file:read("*a")
            file:close()
            return content:find("%[tool%.ty%]") ~= nil
        end

        local servers = {
            clangd = {},
            gopls = {
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            },
            rust_analyzer = {},
            lua_ls = {},
            ts_ls = {},
            ruff = {},
        }

        if should_use_ty() then
            servers.ty = {}
        else
            servers.pyright = {}
        end

        require("mason").setup()

        local ensure_installed = vim.tbl_keys(servers or {})

        local mason_ensure = {}
        for _, s in ipairs(ensure_installed) do
            if s ~= "ty" then table.insert(mason_ensure, s) end
        end
        require("mason-tool-installer").setup({ ensure_installed = mason_ensure })
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server_config = servers[server_name] or {}
                    -- Mescla as capabilities do blink com as configs do servidor
                    server_config.capabilities = vim.tbl_deep_extend("force", capabilities,
                        server_config.capabilities or {})

                    require("lspconfig")[server_name].setup(server_config)
                end,
            },
        })

        if servers.ty then
            require("lspconfig").ty.setup({ capabilities = capabilities })
        end
    end,
}

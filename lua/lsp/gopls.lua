local M = {}

M.active_tags = M.active_tags or {}

function M.get_local_config()
    local config_path = vim.fn.getcwd() .. "/.nvim/lsp.conf"
    if vim.fn.filereadable(config_path) == 1 then
        local ok, config = pcall(dofile, config_path)
        if ok and type(config) == "table" then return config end
    end
    return nil
end

function M.pick_build_flags()
    local conf = M.get_local_config()
    if not conf or not conf.build_flags then
        vim.notify("Nenhuma tag em .nvim/lsp.conf", vim.log.levels.WARN)
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local entry_display = require("telescope.pickers.entry_display")

    local displayer = entry_display.create {
        separator = " ",
        items = { { width = 4 }, { remaining = true } },
    }

    local make_display = function(entry)
        local status = M.active_tags[entry.value] and "[x]" or "[ ]"
        return displayer { { status, "TelescopeResultsSpecial" }, entry.value }
    end

    pickers.new({}, {
        prompt_title = "Go Build Tags (Tab para selecionar)",
        finder = finders.new_table {
            results = conf.build_flags,
            entry_maker = function(entry)
                return { value = entry, display = make_display, ordinal = entry }
            end,
        },
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local function toggle_selection()
                local selection = action_state.get_selected_entry()
                if not selection then return end
                M.active_tags[selection.value] = not M.active_tags[selection.value]

                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:refresh()
            end

            map("i", "<Tab>", toggle_selection)
            map("n", "<Tab>", toggle_selection)

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)

                local selected_list = {}
                for tag, active in pairs(M.active_tags) do
                    if active then table.insert(selected_list, tag) end
                end

                local flag_str = #selected_list > 0 and ("-tags=" .. table.concat(selected_list, ",")) or nil
                local build_flags = flag_str and { flag_str } or {}

                -- 1. Atualiza a configuração GLOBAL (para persistir no restart)
                -- No Neovim 0.11+, usamos a API de configuração para gopls
                vim.lsp.config("gopls", {
                    settings = {
                        gopls = {
                            buildFlags = build_flags
                        }
                    }
                })

                -- 2. Também atualizamos o cliente ATUAL (opcional, mas garante consistência)
                for _, client in ipairs(vim.lsp.get_clients({ name = "gopls" })) do
                    client.config.settings.gopls.buildFlags = build_flags
                end

                -- 3. Agora o restart vai ler a nova config global do passo 1
                vim.cmd("LspRestart gopls")
                vim.notify("Gopls reiniciado com: " .. (flag_str or "sem tags"))
            end)

            return true
        end,
    }):find()
end

return M

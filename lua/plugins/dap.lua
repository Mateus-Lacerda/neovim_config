return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"
            require("dapui").setup()
            require("dap-python").setup()
            require('dap-python').resolve_python = function()
                return VENV_PYTHON_PATH()
            end

            local function substitute_variables(tbl)
                local cwd = vim.loop.cwd()
                local function substitute(value)
                    if type(value) == "string" then
                        value = value:gsub("${workspaceRoot}", cwd)
                        value = value:gsub("${workspaceFolder}", cwd)
                        return value
                    elseif type(value) == "table" then
                        for k, v in pairs(value) do
                            value[k] = substitute(v)
                        end
                        return value
                    else
                        return value
                    end
                end
                return substitute(tbl)
            end
            -- Finds configs in .vscode/launch.json
            local function find_config()
                local cwd = vim.loop.cwd()
                local config_path = cwd .. "/.nvim/launch.json"
                if vim.fn.filereadable(config_path) == 1 then
                    return config_path
                end
                return nil
            end
            -- Load the config from .vscode/launch.json
            local function load_config()
                local config_path = find_config()
                if config_path then
                    local config = vim.fn.json_decode(vim.fn.readfile(config_path))
                    return config
                end
                return nil
            end
            local config = load_config()
            if config then
                for _, cfg in ipairs(config) do
                    cfg = substitute_variables(cfg)
                    cfg.cwd = cfg.cwd or vim.loop.cwd()
                    if cfg.type == "python" or cfg.type == "debugpy" then
                        table.insert(dap.configurations.python, cfg)
                    end
                end
            end
            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F12>", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}

return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
        -- 1. Git Status (Hide ignored / Show tracked hidden)
        local function parse_output(proc)
            local result = proc:wait()
            local ret = {}
            if result.code == 0 then
                for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
                    line = line:gsub("/$", "")
                    ret[line] = true
                end
            end
            return ret
        end

        local function new_git_status()
            return setmetatable({}, {
                __index = function(self, key)
                    local ignore_proc = vim.system(
                        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                        { cwd = key, text = true }
                    )
                    local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
                        cwd = key,
                        text = true,
                    })
                    local ret = {
                        ignored = parse_output(ignore_proc),
                        tracked = parse_output(tracked_proc),
                    }
                    rawset(self, key, ret)
                    return ret
                end,
            })
        end

        local git_status = new_git_status()

        -- Clears git cache on Oil refresh
        local refresh = require("oil.actions").refresh
        local orig_refresh = refresh.callback
        refresh.callback = function(...)
            git_status = new_git_status()
            orig_refresh(...)
        end

        -- 2. Setup
        local detail = false
        require("oil").setup({
            keymaps = {
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
            },
            view_options = {
                is_hidden_file = function(name, bufnr)
                    local dir = require("oil").get_current_dir(bufnr)
                    local is_dotfile = vim.startswith(name, ".") and name ~= ".."
                    if not dir then
                        return is_dotfile
                    end
                    if is_dotfile then
                        return not git_status[dir].tracked[name]
                    else
                        return git_status[dir].ignored[name]
                    end
                end,
            },
        })
    end,
}

return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim'
    },
    opts = {
        defaults = {
            file_ignore_patterns = { '.git/', 'node_modules/', '.venv/' },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown({})
            }
        }
    },
    config = function()
        require("telescope").load_extension("ui-select")
    end
}

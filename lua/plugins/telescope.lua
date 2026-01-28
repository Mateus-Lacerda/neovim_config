return {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    opts = {
        defaults = {
            file_ignore_patterns = { '.git/', 'node%_modules/', '.venv/' },
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

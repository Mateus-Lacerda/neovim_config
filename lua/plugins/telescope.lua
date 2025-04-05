return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            file_ignore_patterns = { '.git/', 'node_modules/', '.venv/' },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        }
    }
}

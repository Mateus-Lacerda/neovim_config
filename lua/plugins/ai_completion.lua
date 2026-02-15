return {
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('minuet').setup({
                provider = 'openai_fim_compatible',
                n_completions = 1,
                context_window = 512,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = 'TERM',
                        name = 'Ollama',
                        end_point = 'http://localhost:11434/v1/completions',
                        model = 'qwen2.5-coder:7b',
                        optional = {
                            max_tokens = 56,
                            top_p = 0.9,
                        },
                    },
                },
                virtualtext = {
                    auto_trigger_ft = {},
                    keymap = {
                        accept = '<C-y>',
                        dismiss = '<C-;>',
                    },
                    request_timeout = 5000,
                },
                throttle = 900,
                debounce = 600,
            })
            vim.keymap.set('n', '<leader>ai', '<cmd>Minuet virtualtext toggle<cr>', { desc = 'Toggle Minuet AI' })
        end,
    },
}

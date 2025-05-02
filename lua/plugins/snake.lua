return {
    'Mateus-Lacerda/snake.nvim',
    config = function()
        require('snake_game').setup({
            nerd_font = true, -- Set to false if you don't want to use Nerd Fonts
        })
    end
}

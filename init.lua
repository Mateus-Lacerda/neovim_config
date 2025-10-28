print("Welcome back baby!")
vim.g.mapleader = ' '
vim.g.maplocalleader = '//'
vim.g.have_nerd_font = true
vim.g.gruvbox_contrast_dark = 'hard'

vim.loader.enable()

require('config.lazy')
require('mappings')
require('opt')
require('utils')
require('autocmds')
require('local')
require('lsp')
require('macros')

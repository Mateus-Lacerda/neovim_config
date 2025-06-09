print("Welcome back baby!")
vim.g.mapleader = ' '
vim.g.maplocalleader = '//'
vim.g.have_nerd_font = true

vim.loader.enable()

require('config.lazy')
require('mappings')
require('opt')
require('utils')
require('autocmds')
require('local')
-- require('lsp')

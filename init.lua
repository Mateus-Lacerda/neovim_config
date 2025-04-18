print("Welcome back baby!")
vim.g.mapleader = ' '
vim.g.maplocalleader = '//'

vim.loader.enable()

require('config.lazy')
require('mappings')
require('opt')
require('utils')
require('autocmds')

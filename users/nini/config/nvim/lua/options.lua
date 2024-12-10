vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "

local options = { noremap = true }
vim.keymap.set("i", "jj", "<Esc>", options)

vim.o.clipboard = 'unnamedplus'

vim.o.number = true

vim.o.signcolumn = 'yes'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = 'a'

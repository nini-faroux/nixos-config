-- Free up space for mappings
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
-- Set leader to space
vim.g.mapleader = " "

local options = { noremap = true }
-- Use double j tap for escape
vim.keymap.set("i", "jj", "<Esc>", options)

-- Sync NVim with system clipboard
vim.o.clipboard = 'unnamedplus'

-- Show absolute line numbers
vim.o.number = true

-- Always show sign column (empty if no signs)
vim.o.signcolumn = 'yes'

-- Tabs / Spaces
vim.o.tabstop = 4
-- How many spaces to use for indent
vim.o.shiftwidth = 2
-- Pressing <Tab> uses spaces instead of tab
vim.o.expandtab = true
-- How many spaces when pressing <Tab>
vim.o.softtabstop = 2

-- Shorter than default idle time
vim.o.updatetime = 300

-- Enable 24-bit RGB colours in terminal
vim.o.termguicolors = true

-- ------------------------
-- Cursor & mouse settings
-- ------------------------

-- Disable mouse
vim.o.mouse = ""

-- Hide terminal cursor at startup
local function hide_terminal_cursor()
  if vim.fn.has("unix") == 1 and vim.fn.exists("$TERM") == 1 then
    vim.cmd([[silent !tput civis]])  -- hide terminal cursor
  end
end

local function show_terminal_cursor()
  if vim.fn.has("unix") == 1 and vim.fn.exists("$TERM") == 1 then
    vim.cmd([[silent !tput cnorm]])  -- restore terminal cursor
  end
end

-- Autocommands to hide/show cursor on enter/exit
vim.api.nvim_create_autocmd("VimEnter", { callback = hide_terminal_cursor })
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend", "FocusLost"}, { callback = show_terminal_cursor })

-- make cursor invisible in Insert mode:
vim.o.guicursor =
  "n:block,i:ver25-iCursor"  -- normal block, insert thin invisible

-- and then define iCursor highlight as background:
vim.cmd [[
  highlight iCursor guifg=NONE guibg=NONE blend=100
]]

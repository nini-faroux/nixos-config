require('nvim-treesitter').setup {
    ensure_installed = { 'haskell', 'vim', 'vimdoc', 'lua', 'markdown', 'markdown_inline', 'yaml' },

    auto_install = false,

    highlight = { enable = true },

    indent = { enable = true },

	-- Avoid read-only fs error
	parser_install_dir = vim.fn.stdpath("cache") .. "/nvim-treesitter/parsers",
}

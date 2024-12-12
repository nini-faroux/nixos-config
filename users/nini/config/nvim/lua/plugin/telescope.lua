require('telescope').setup({
	extensions = {
    	  fzf = {
      	  fuzzy = true,
      	  override_generic_sorter = true,
      	  override_file_sorter = true,
      	  case_mode = "smart_case",
    	  },
        },

	defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
	          ["<C-k>"] = "move_selection_previous",
              ["<C-j>"] = "move_selection_next",
            }
          }
        },
})

vim.keymap.set("n", "<space>ff", require('telescope.builtin').find_files)
vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
vim.keymap.set("n", "<space>fg", require('telescope.builtin').live_grep)

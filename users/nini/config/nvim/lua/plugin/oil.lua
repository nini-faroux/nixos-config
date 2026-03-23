require('oil').setup {
  watch_for_changes = true,

  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- Optional: Define custom logic for what is considered hidden
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, '.')
    end,
    -- Prevent specific files/dirs from being shown even if `show_hidden` is true
    is_always_hidden = function(name, bufnr)
      return false
    end,
  }
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

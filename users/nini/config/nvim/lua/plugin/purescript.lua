-- require('purescript-contrib/purescript-vim').setup({})

-- require('lspconfig').purescriptls.setup {
--   on_attach = on_attach,
--   settings = {
--     purescript = {
--       addSpagoSources = true -- e.g. any purescript language-server config here
--     }
--   },
--   flags = {
--     debounce_text_changes = 150,
--   }
-- }

require'lspconfig'.purescriptls.setup{}

--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = { "purescript-language-server", '--stdio' },
--   filetypes = { 'purescript' },
--   root_dir = function(startpath)
--       return M.search_ancestors(startpath, matcher)
--     end
-- }

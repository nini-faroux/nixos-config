" Use pathogen for plugins
execute pathogen#infect()

" set syntax highlighting
syntax enable

" Spaces / Tabs 

" number of visual spaces per TAB
set tabstop=4

" number of spaces in tab when editing
set softtabstop=4

" indentation
set shiftwidth=2

" tabs are spaces
set expandtab

" UI Config
" show line numbers
set number

" show command in bottom bar
set showcmd

" highlight current line 
set cursorline

" load filetype-specific indent files
filetype indent on
filetype on
filetype plugin indent on

" visual autocomplete for command menu
set wildmenu

" redraw only when we need to
set lazyredraw

" highlight matching brackets,...
set showmatch

" Searching 
" search as characters are entered
set incsearch

" highlight matches
set hlsearch

" set turn off search highlight to <CTRL-L>
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Folding
" enable folding
set foldenable

" open most folds by default
set foldlevelstart=10

" 10 nested fold max
set foldnestmax=10

" Remap Leader
let mapleader = "\<Space>"
let maplocalleader = ","

" space open/closes folds
nnoremap <space> za

" Replace Esc with jj
inoremap jj <Esc>

" fold based on indent level
set foldmethod=indent
  
" Persistent Undo
set undofile
set undodir=$HOME/.vim/undo

set undolevels=1000
set undoreload=10000

"" Copy to clipboard
set clipboard+=unnamedplus

lua << EOF
  -- Setup language servers.
  local lspconfig = require('lspconfig')

  require('lspconfig')['hls'].setup{
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
  }
  lspconfig.aiken.setup{}
  lspconfig.purescriptls.setup{}

  lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
      ['rust-analyzer'] = {},
    },
  }
  
  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
  
  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  
      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })
EOF

" FZF 
set rtp+=/usr/local/opt/fzf

" Search current directory
nnoremap <Leader>f :Files<Cr>

" Search home directory
nnoremap <Leader>F :FZF ~<cr>

" Search root directory
nnoremap <Leader>f, :FZF /<cr>

" Search git files
nnoremap <Leader>fg :GFiles<CR>

" Search buffers
nnoremap <Leader>b :Buffers<CR>

" Search buffer history
nnoremap <Leader>h :History<CR>

" ripgrep
nnoremap <Leader>, :Rg<Space>

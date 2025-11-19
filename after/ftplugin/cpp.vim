setlocal signcolumn=yes

" Search for function definition
nnoremap <silent> <buffer> g: /<c-r><c-w><c-b>::<cr>

" Insert a Doxygen-style comment block
command DoxyBlock normal O/**<cr><tab>@brief<cr>/<esc>k

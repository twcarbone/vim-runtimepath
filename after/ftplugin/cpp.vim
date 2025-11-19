setlocal signcolumn=yes

" Search for function definition
nnoremap <silent> <buffer> g: /<c-r><c-w><c-b>::<cr>

" Insert a Doxygen-style comment block
command -buffer DoxyBlock normal O/**<cr><tab>@brief<cr>/<esc>k

call utils#set_undo_ftplugin('setlocal scl< | silent! nunmap <buffer> g: | delcommand -buffer DoxyBlock')

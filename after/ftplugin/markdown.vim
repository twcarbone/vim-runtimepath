setlocal autoindent
setlocal comments=fb:-,fb:*,fb:>
setlocal formatoptions=tcrnq

nnoremap <buffer> <leader>r gwip

call utils#set_undo_ftplugin('setlocal ai< com< fo< | silent! nunmap <buffer> <leader>r')

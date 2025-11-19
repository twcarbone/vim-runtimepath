" Do not load global ftplugin
let b:did_ftplugin = 1

setlocal autoindent
setlocal comments=fb:-,fb:*,fb:>
setlocal formatoptions=tcrnq
setlocal colorcolumn=90,100

call utils#set_undo_ftplugin('setlocal ai< com< fo< cc<')

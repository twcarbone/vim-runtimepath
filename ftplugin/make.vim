" Do not load global ftplugin
let b:did_ftplugin = 1

" Same settings as $VIMRUNTIME/ftplugin/make.vim, EXCEPT the tab settings.
setlocal fo-=t fo+=croql
setlocal com=sO:#\ -,mO:#\ \ ,b:#
setlocal commentstring=#\ %s
let &l:include = '^\s*include'

call utils#set_undo_ftplugin('setlocal fo< com< cms< inc<')

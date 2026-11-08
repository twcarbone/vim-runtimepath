" Usage
"   :make %         Runs mypy on current file
"   :make <dir/>    Runs mypy on all files in <dir/>
"   :make <file>    Runs mypy on <file>
setlocal makeprg=$HOME/.pytools/bin/mypy\ $*

function! <SID>PythonGoToLocalDecl(word)
    if len(a:word) == 0
        echohl ErrorMSg
        " This throws 'E349' when 'gd' is used normally.
        echo "error: no identifier under cursor"
        echohl NONE
        return
    endif

    if search('^\(def\|async def\)', 'Wb') == 0
        " Not inside function definition. Behave like 'gD'.
        return feedkeys("gD", "n")
    endif

    let @/ = $'\V\<{a:word}\>'
    normal! n

    while getline('.') =~# '^\s*#'
        normal! n
    endwhile

    " After many attempts, using let @/ = '...' and returning this feedkeys(...)
    " expression is the only way to get the highlighting behavior to match regular 'gd'.
    return feedkeys(":let v:hlsearch = 1\<cr>", "n")
endfunction

nnoremap <silent> <buffer> gd :call <SID>PythonGoToLocalDecl(expand('<cword>'))<cr>

setlocal colorcolumn=100,120

call utils#set_undo_ftplugin('setlocal mp< cc< | silent! nunmap <buffer> gd')

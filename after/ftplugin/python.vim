" Usage
"   :make %         Runs mypy on current file
"   :make <dir/>    Runs mypy on all files in <dir/>
"   :make <file>    Runs mypy on <file>
setlocal makeprg=$HOME/.pytools/bin/mypy\ $*

function! <SID>PythonGoToLocalDecl(word)
    if len(a:word) == 0 || search('^\(def\|async def\)', 'Wb') == 0
        " If not on an identifier or not inside a function, falling back to normal
        " 'gd' gives the behavior we want.
        return feedkeys('gd', 'n')
    endif

    let @/ = $'\V\<{a:word}\>'
    normal! n

    while getline('.') =~# '^\s*#'
        normal! n
    endwhile

    " Turn on search highlighting if it is enabled, then redraw so the :let command
    " doesn't linger in the command line. Causes small command-line flicker.
    call feedkeys(":let v:hlsearch = 1\<cr>", "n")
    call feedkeys(":redraw!\<cr>", "n")
endfunction

nnoremap <silent> <buffer> gd :call <SID>PythonGoToLocalDecl(expand('<cword>'))<cr>

setlocal colorcolumn=100,120

call utils#set_undo_ftplugin('setlocal mp< cc< | silent! nunmap <buffer> gd')

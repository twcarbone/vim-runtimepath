function! utils#error(str)
    echohl ErrorMsg
    echo "Error: " .. a:str
    echohl None
endfunction


function! utils#info(str)
    redraw
    echo "Info: " .. a:str
endfunction


" @brief
"   Open a file for editing, if it exists.
"
" @return
"   0 (success) if the file exists
"   1 (fail) if the file does not exist
"
function! utils#editifexists(path)
    if filereadable(a:path) == 0
        call utils#error("no such file: " .. a:path)
        return 1
    else
        execute "edit " .. a:path
        return 0
    endif
endfunction


" @brief
"   Source vimrc file
"
" @note
"   Call redraw to avoid the message being immediately discarded
"   See https://www.reddit.com/r/vim/comments/10107hs/
"
function! utils#sourcevimrc()
    if !pathlib#exists($MYVIMRC)
        call utils#error($"no such file: {$MYVIMRC}")
        return 1
    endif
    source $MYVIMRC
    redraw  " see @note
    call utils#info($"Sourcing {$MYVIMRC} ... OK")
endfunction


" @brief
"   Format a range according to the buffer file type.
"
" @bug
"   Formatting buffer with range does not respect contextual indentation
"   https://github.com/twcarbone/dot_files/issues/5
"
function! utils#formatrange() range
    let l:err = 0
    silent write
    if &filetype ==# "c" || &filetype ==# "cpp"
        silent execute a:firstline ',' a:lastline '!clang-format'
    elseif &filetype ==# "csv"
        silent execute a:firstline ',' a:lastline '!column -s, -t'
    elseif &filetype ==# "json"
        silent execute a:firstline ',' a:lastline '!jq --indent 4 .'
    elseif &filetype ==# "python"
        silent execute a:firstline ',' a:lastline '!~/.pytools/bin/black - -q'
        silent execute a:firstline ',' a:lastline '!~/.pytools/bin/isort --force-single-line-imports -'
    elseif &filetype ==# "xml"
        call setenv("XMLLINT_INDENT", "    ")
        silent execute a:firstline ',' a:lastline '!xmllint --format -'
    elseif &filetype ==# "html"
        silent execute a:firstline ',' a:lastline '!tidy -q'

        if v:shell_error != 0
            let l:err = 1
        else
            " Remove <meta ...> that is added in by tidy
            silent execute 'global /HTML Tidy/ normal dd'
            " Add blank line above certain elements
            silent execute 'global /^<h1\|^<h2\|^<p>\|^<div/ normal O'
        endif
    else
        call utils#error("formatrange: filetype not supported: " .. &filetype)
        return
    endif

    if l:err == 1
        normal u
        call utils#error("formatrange: formatting ... Error")
    else
        call utils#info("formatrange: formatting ... OK")
    endif

    silent write
endfunction


" @brief
"   Edit the 'alternate' file of this file.
"
"   For C++ header files, this locates the associated source file. For C++ source files,
"   this locates the associated header file.
"
function! utils#altfile()
    silent write

    let l:altfile_tails = {'c': 'h', 'cpp': ['h', 'hpp'], 'h': ['c', 'cpp'], 'hpp': ['cpp']}

    try
        let l:alt_tails = l:altfile_tails[pathlib#tail()]
    catch /^Vim\%((\a\+)\)\=:E716:/
        call utils#error("File tail must be one of: " .. join(keys(l:altfile_tails), ', '))
        return
    endtry

    let l:gitdir = pathlib#fd_u(".git", pathlib#parent())

    for l:alt_tail in l:alt_tails
        let l:alt_name = pathlib#name(pathlib#with_tail(l:alt_tail))

        if l:gitdir != ""
            let l:file = pathlib#ff_d(l:alt_name, pathlib#parent(l:gitdir), 10)
        else
            let l:file = pathlib#ff(l:alt_name, pathlib#parent())
        endif

        if l:file != ''
            break
        endif
    endfor

    if l:file == ''
        call utils#error("Cannot find alternate file")
        return
    endif

    call pathlib#edit(l:file)
endfunction


" @brief
"   Enclose a range with `#if 0` and `#endif`
"
function! utils#disable() range
    if index(["c", "cpp", "h"], expand("%:e")) == -1
        call utils#error("Must be c file")
        return
    endif
    let failed = append(a:firstline - 1, "#if 0")
    let failed = append(a:lastline + 1, "#endif")
endfunction


" @brief
"   Remove `#if 0` and `#endif` macros from a range.
"
" @post
"   Lines `#if 0` and `#endif` deleted from the current buffer.
"
" @note
"   Range must start and end on `#if 0` and `#endif`, respectively.
"
function! utils#enable() range
    if index(["c", "cpp", "h"], expand("%:e")) == -1
        call utils#error("Must be c file")
        return
    elseif getline(a:firstline) != "#if 0"
        call utils#error("Range must start with '#if 0'")
        return
    elseif getline(a:lastline) != "#endif"
        call utils#error("Range must end with '#endif'")
        return
    endif
    silent execute a:lastline 'd'
    silent execute a:firstline 'd'
endfunction


" @brief
"   Compare two C-style declarations
"
" @return
"    =  0 if lines are equal
"   >=  1 if lhs sorts after rhs
"   <= -1 if lhs sort before rhs
"
" @example
"
"   bool finished;
"   QString name;
"   int count;
"
"   sorts to:
"
"   int count;
"   bool finished;
"   QString name;
"
function! utils#membercompare(lhs, rhs)
    let l:lhs_words = split(a:lhs)
    let l:rhs_words = split(a:rhs)
    return strlen(l:lhs_words[0]) - strlen(l:rhs_words[0])
endfunction


" @brief
"   Sort from `nFirstLine` to `nLastLine` in the current buffer according to compare
"   function `func`.
"
" @post
"   In-place sort of `nFirstLine` through `nLastLine` in the current buffer.
"
" @return
"   0 for success, 1 for failure
"
function! utils#sortbuflines(nFirstLine, nLastLine, func)
    let l:lines = getline(a:nFirstLine, a:nLastLine)
    let failed = deletebufline(bufname(), a:nFirstLine, a:nLastLine)
    let l:sortedlines = sort(l:lines, a:func)
    return append(a:nFirstLine - 1, l:sortedlines)
endfunction


" @brief
"   Sort C-style declarations
"
" @example
"
"   bool finished;
"   QString name;
"   int count;
"
"   sorts to
"
"   int count;
"   bool finished;
"   QString name;
"
function! utils#membersort() range
    call utils#sortbuflines(a:firstline, a:lastline, "utils#membercompare")
endfunction


" @brief
"
" @notes
"   Credit to: https://stackoverflow.com/a/6271254

function! utils#interactivechangeword()
    let [l:nLineStart, l:nColStart] = getpos("'<")[1:2]
    let [l:nLineEnd, l:nColEnd] = getpos("'>")[1:2]
    if l:nLineStart != l:nLineEnd
        call utils#error("cannot process multiline selection")
    endif
endfunction


function! utils#incrementnumbers() range
"'<,'>s/\%V\d\+\%V/\=submatch(0)+1/g
endfunction


" @brief
"   Remove ANSI escape sequences
"
function! utils#rmansiseq()
    " Search by either '\e' or '\033'
    %s/\(\e\|\033\)\[.\{-}m//g
endfunction


" @brief
"   Remove all trailing whitespace
"
function! utils#kill_trailing_whitespace()
    %s/\s\+$//ge
endfunction


" @brief
"   Set 'b:undo_ftplugin'
"
function! utils#set_undo_ftplugin(commands)
    if exists('b:undo_ftplugin')
        let b:undo_ftplugin = a:commands .. ' | ' .. b:undo_ftplugin
    else
        let b:undo_ftplugin = a:commands
    endif
endfunction

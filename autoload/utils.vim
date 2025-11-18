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
    if filereadable(expand("~/.vimrc")) == 0
        call utils#error("no such file: ~/.vimrc")
        return 1
    endif
    source ~/.vimrc
    redraw  " see @note
    call utils#info("Sourcing ~/.vimrc ... OK")
endfunction


" @brief
"   Format a range according to the buffer file type.
"
" @detail
"   Supported file types:
"       h, c, cpp
"       csv
"       python
"
" @bug
"   Formatting buffer with range does not respect contextual indentation
"   https://github.com/twcarbone/dot_files/issues/5
"
function! utils#formatrange() range
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
        " Remove <meta ...> that is added in by tidy
        silent execute 'global /HTML Tidy/ normal dd'
    else
        call utils#error("formatrange: filetype not supported: " .. &filetype)
        return
    endif
    call utils#info("formatrange: formatting ... OK")
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

    if pathlib#tail() == 'h'
        let l:alt_tail = 'cpp'
    elseif pathlib#tail() == 'cpp'
        let l:alt_tail = 'h'
    else
        call utils#error("Must be .h or .cpp file")
        return
    endif

    let l:name = pathlib#name(pathlib#with_tail(l:alt_tail))
    let l:file = pathlib#ff(l:name, pathlib#parent())

    if l:file != ''
        call pathlib#edit(l:file)
    else
        call utils#error($"cannot find file: {l:name}")
    endif
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

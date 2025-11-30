" Must be run from test/ directory
source ../autoload/pathlib.vim

function! RunTheTest(test)
    if exists("*SetUp")
        call SetUp()
    endif

    execute 'call ' .. a:test

    if exists("*TearDown")
        call TearDown()
    endif

    call add(s:messages, 'Executed ' .. a:test)
    let s:done += 1
endfunction

func AfterTheTest(func_name)
    if len(v:errors) > 0
        let s:fail += 1
        call add(s:errors, 'Found errors in ' . g:testfunc . ':')
        call extend(s:errors, v:errors)
        let v:errors = []
    endif
endfunc

function FinishTesting()
    set viminfo=

    " Create the result file if all tests pass
    if s:fail == 0
        exe 'split ' . fnamemodify(g:testname, ':r') . '.res'
        write
    endif

    " Write errors to 'test.log'
    if len(s:errors) > 0
        split test.log
        call append(line('$'), '')
        call append(line('$'), 'From ' . g:testname . ':')
        call append(line('$'), s:errors)
        write
    endif

    " Write qty of tests executed to 'messages'
    let message = 'Executed ' . s:done . (s:done > 1 ? ' tests' : ' test')
    echo message
    call add(s:messages, message)

    if s:fail > 0
        let message = s:fail . ' FAILED:'
        echo message
        call add(s:messages, message)
        call extend(s:messages, s:errors)
    endif

    split messages
    call append(line('$'), '')
    call append(line('$'), 'From ' . g:testname . ':')
    call append(line('$'), s:messages)
    write

    qall!
endfunction

let g:testname = expand('%')
let s:done = 0
let s:fail = 0
let s:errors = []
let s:messages = []

source %

" Locate Test_ functions
redir @q
silent function /^Test_
redir END
let s:tests = split(substitute(@q, '\(function\) \(\k*()\)', '\2', 'g'))

" Run each Test_ function in alphabetical order
for g:testfunc in sort(s:tests)
    call RunTheTest(g:testfunc)
    call AfterTheTest(g:testfunc)
endfor

call FinishTesting()

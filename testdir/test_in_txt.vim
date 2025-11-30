function! SetUp()
    edit in.txt
    let s:before = readfile('in.txt')
endfunction

function! TearDown()
    write
    let s:after = readfile('in.txt')
    call assert_equal(s:before, s:after)
    bd!
endfunction

function! Test_simple_paragraph_section1()
    call cursor(3, 0)
    normal! gwip
endfunction

function! Test_bullet_list_section2()
    call cursor(9, 0)
    normal! gwip
endfunction

function Test_bullet_list_section3()
    call cursor(16, 0)
    normal! gw2j
endfunction

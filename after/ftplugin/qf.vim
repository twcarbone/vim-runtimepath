set nospell
set colorcolumn=

nnoremap <buffer> <c-n> :cn<cr><c-w>p
nnoremap <buffer> <c-p> :cp<cr><c-w>p

nnoremap <silent> <buffer> cne   /error:<cr>
nnoremap <silent> <buffer> cpe   ?error:<cr>
nnoremap <silent> <buffer> cnw   /warning:<cr>
nnoremap <silent> <buffer> cpw   ?warning:<cr>
nnoremap <silent> <buffer> ce    :Cfilter /error:/<cr>
nnoremap <silent> <buffer> cw    :Cfilter /warning:/<cr>
nnoremap <silent> <buffer> u     :colder<cr>
nnoremap <silent> <buffer> <c-r> :cnewer<cr>

function! SmartJump(direction)
    let l:list = getqflist()
    let l:current = getqflist({'idx': 0}).idx - 1
    let l:range = a:direction == 'next'
                \ ? range(l:current + 1, len(l:list) - 1)
                \ : reverse(range(0, l:current - 1))

    for i in l:range
        if l:list[i].text =~# 'error:'
            execute 'cc ' .. (i + 1)
            wincmd p
            return
        endif
    endfor

    echohl WarningMsg | echo "No more errors in that direction." | echohl None
endfunction

nnoremap <silent> ]e :call SmartJump('next')<cr>
nnoremap <silent> [e :call SmartJump('prev')<cr>

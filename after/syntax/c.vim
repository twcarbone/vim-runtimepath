" As of vim 9.1.0698, $VIMRUNTIME/syntax/c.vim also syntax highlights within a #define
" using 'contains=...'. Redefine here without 'contains=...' to disable highlighting.
syn region  cDefine     start="^\s*\zs\%(%:\|#\)\s*\%(define\|undef\)\>" skip="\\$" end="$" keepend

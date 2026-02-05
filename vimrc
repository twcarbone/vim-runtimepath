" ========================================================================================
" Contents
"
"   1.  Options and builtin settings
"   2.  Plugin settings
"   3.  Commands
"   4.  Mappings
"   5.  Functions
"   6.  Autocommands
"

" ========================================================================================
" 1. Options and builtin settings

" see
"   :h xterm-true-color
"   :h termguicolors
"   :h t_8f
"   :h t_8b
"
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

colorscheme gruber
filetype plugin indent on
set backspace=indent,eol,start
set breakindent
set cinoptions+=f0
set cinoptions+=g0
set cmdwinheight=12
set colorcolumn=100
set cursorline
set directory=$HOME/vimswap//
set display=truncate
set expandtab
set foldcolumn=1
set formatoptions=croqj
if has('patch-8.2.4907')
    set formatoptions+=/
endif
set hidden
set hlsearch
set ignorecase
set incsearch
set keywordprg=:Man
set laststatus=2
set linebreak
set list
set listchars=trail:∙,tab:→\∙
set makeprg=make\ -j
set nojoinspaces
set number
set pastetoggle=<F2>
set relativenumber
set scrolloff=2
set shiftwidth=4
set showcmd
set smartcase
set softtabstop=4
set spell
if has('patch-8.2.0953')
    set spelloptions=camel
endif
set splitbelow
set splitright
set statusline=\ %y%r\ %f\%m\ %4p%%\ (%l,%c)\ 0x%B\ (%b)%=%{getcwd()}
set tabline=%!Tabline()
set tabstop=4
set termguicolors
set textwidth=89
set timeout
set timeoutlen=500
set ttimeoutlen=1000
set updatetime=100
set virtualedit=block
set wildignorecase
set wildmenu
set wildmode=longest:full
set wildoptions=pum
syntax on

if !isdirectory(&directory)
    call mkdir(&directory, 'p', 0700)
endif

let g:netrw_sizestyle = 'H'
let g:netrw_liststyle = 1
let g:netrw_sort_sequence = '[\/]\s'


" ========================================================================================
" 2. Plugin settings

" Builtin
runtime ftplugin/man.vim
packadd! matchit
packadd! cfilter

" Python
let g:pyindent_open_paren = 'shiftwidth()'
let g:python_no_doctest_highlight = 1

" YouCompleteMe
let g:ycm_add_preview_to_completeopt="popup"
let g:ycm_auto_hover = ""
let g:ycm_clangd_args=['--header-insertion=never', '-log=verbose', '-pretty']
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_echo_current_diagnostic = 1 " or 'virtual-text'
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_error_symbol = "E"
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_show_detailed_diag_in_popup = 1
let g:ycm_update_diagnostics_in_insert_mode = 0 " recommended for ycm_echo_current_diagnostic = 'virtual-text'
let g:ycm_warning_symbol = "W"

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx,*.xml'
let g:closetag_filetypes = 'html,xhtml,phtml,js,jsx,ts,tsx,xml'

" vim-commentary

" vim-fzf
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']
let g:fzf_layout = { 'down': '50%' }

" vim-gitgutter

" vim-pydoc
let g:pydoc_cmd = 'python3 -m pydoc'
let g:pydoc_highlight = 0
let g:pydoc_window_lines = 0.5


" ========================================================================================
" 3. Commands

" :H
"           Opens help in new buffer
command! -nargs=? -complete=help H :enew | :set buftype=help | :h <args>

" :FormatRange
"           This command is a thin wrapper around FormatRange() to allow the cursor and
"           viewport to return to the original position. Without this, FormatRange puts
"           the cursor at the beginning of the range after completing. When the range is
"           the entire buffer, this means jumping to line 1... sigh.
"
"           (inspired by: https://stackoverflow.com/a/73002057)
command! -range -bar FormatRange
    \ let s:view = winsaveview() |
    \ <line1>,<line2>call utils#formatrange() |
    \ call winrestview({'lnum': s:view.lnum, 'col': s:view.col, 'topline': s:view.topline})

" :Rg
"           Alternate vim-fzf :Rg command to not match filenames.
"
"           (inspired by: https://stackoverflow.com/a/62745519)
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \     "rg --line-number --no-heading --color=always --smart-case -- " .. fzf#shellescape(<q-args>),
    \     fzf#vim#with_preview({'options': '--delimiter=: --nth=3..'}),
    \     <bang>0
    \ )

command! -range Disable <line1>,<line2>call utils#disable()
command! -range Enable <line1>,<line2>call utils#enable()
command! -range MemberSort <line1>,<line2>call utils#membersort()
command! KillTrailingWhitespace call utils#kill_trailing_whitespace()
command! RmAnsiSeq call utils#rmansiseq()
command! SourceVimrc call utils#sourcevimrc()
command! Messages call utils#messages()


" ========================================================================================
" 4. Mappings

" Emacs-style command line bindings
cnoremap <c-a>     <home>
cnoremap <esc>b    <s-left>
cnoremap <esc>f    <s-right>
cnoremap <esc><bs> <c-w>

" Mimic bash <c-r> to show history from command line (: or /)
cnoremap <silent> <expr> <c-r> <SID>History()

tnoremap <esc> <c-w>N
tnoremap jk    <c-w>N
inoremap jk    <esc>

" C and D delete or change until the end of the line, but Y doesn't
" see :h Y
noremap Y y$

" Jump to beginning and end of line easier
noremap H ^
noremap L $

" Auto-closing
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap ` ``<left>
inoremap { {}<left>

" Easier window navigation
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

" Ctrl-s to write current buffer
nnoremap <c-s> :w<cr>

" Leader
 noremap <silent> <leader>0         :tablast<cr>
 noremap          <leader>1         1gt
 noremap          <leader>2         2gt
 noremap          <leader>3         3gt
 noremap          <leader>4         4gt
 noremap          <leader>5         5gt
 noremap          <leader>6         6gt
 noremap          <leader>7         7gt
 noremap          <leader>8         8gt
 noremap          <leader>9         9gt
nnoremap <silent> <leader>a         :call utils#altfile()<cr>
nnoremap          <leader>b         :Buffers<cr>
nnoremap <silent> <leader>c         :nohlsearch<cr> :.,$s/<c-r><c-w>/<c-r><c-w>/gc<c-f>bbb
nnoremap <silent> <leader>d         :YcmCompleter GoTo<cr>
 noremap <silent> <leader>e         :nohlsearch<cr>
nnoremap          <leader>f         :Files<cr>
nnoremap          <leader>g         :GFiles<cr>
nnoremap          <leader>i         :Rg<cr>
nnoremap          <leader>j         :Jumps<cr>
nnoremap          <leader>l         :BLines<cr>
nnoremap <silent> <leader>r         :%FormatRange<cr>
vnoremap <silent> <leader>r         :call utils#formatrange()<cr>
nnoremap <silent> <leader>s         :SourceVimrc<cr>
nnoremap <silent> <leader><tab>     :bn<cr>

" Other
    imap <expr>   <cr>              search('\%#[])}]', 'n') ? '<cr><esc>O' : '<cr>'
inoremap          <tab>             <plug>(zz-snap)
nnoremap <expr>   *                 ':%s/'.expand('<cword>').'//gn<CR>'
nnoremap <silent> -                 :call pathlib#edit(pathlib#parent())<cr>


" ========================================================================================
" 5. Functions
"
" See
"   :h autoload-functions
"   :h autoload


" @brief
"   <Tab> indents if at the beginning of the line, otherwise does completion
"
" @author
"   https://github.com/mislav/vimfiles
"
function! s:InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction


" @brief
"   Set the terminal width to margin columns less than the available space.
"
" @detail
"   This is a workaround to address the situation where long lines are wrapped in the
"   terminal by inserting newlines in the terminal output. When going to terminal normal
"   mode (and showing line numbers) the wrapping gets ugly. This basically pads the
"   terminal so that showing line numbers doesn't fudge up the wrapping.
"
" @see
"   https://github.com/vim/vim/issues/2865.
"
function! s:SetTermWindowMargin(margin)
    execute "set termwinsize=0x" . (winwidth("%") - a:margin)
endfunction


function! s:HandleTerminalOpen()
    set nospell
    set colorcolumn=
    set nohidden
    call <SID>SetTermWindowMargin(6)
endfunction


function! s:HandleVimResized()
    call <SID>SetTermWindowMargin(6)
endfunction


function! s:HandleCmdWinEnter()
    set colorcolumn=
endfunction


function! s:RestoreCursorPosition()
    if &filetype =~ 'git'
        return
    endif

    let line = line("'\"")
    if line < 1 || line > line("$")
        return
    endif

    exe "normal! g'\""
endfunction


function! s:History()
    let cmdtype = getcmdtype()
    if cmdtype == ':'
        return "History:\<cr>"
    elseif cmdtype == '/'
        return "\<c-c>:History/\<cr>"
    endif
endfunction


" @brief
"   Show the name of the active buffer in the tab.
"
" @author
"   https://github.com/mkitt/tabline.vim
"
function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . tab .':'
        let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif
    endfor

    let s .= '%#TabLineFill#'
    if (exists("g:tablineclosebutton"))
        let s .= '%=%999XX'
    endif
    return s
endfunction


" ========================================================================================
" 6. Autocommands

augroup __twc_terminal
    autocmd!
    autocmd TerminalOpen * call <SID>HandleTerminalOpen()
    autocmd VimResized * call <SID>HandleVimResized()
augroup END


augroup __twc_cmdwin
    autocmd!
    autocmd CmdwinEnter [:/?] call <SID>HandleCmdWinEnter()
augroup END


augroup __twc_misc
    autocmd!
    autocmd BufReadPost * call <SID>RestoreCursorPosition()
augroup END

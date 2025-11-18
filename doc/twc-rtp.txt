=========================================================================================
1. Startup

    1.  Set shell/term ~

    2.  Command-line arguments ~

    3.  Process vimrc files ~
        `:$HOME/.vimrc`

    4.  Load plugin scripts ~
        `:runtime! plugin/**/*.vim`
        `:packloadall`
        `:runtime! after/plugin/**/*.vim`

=========================================================================================
2. Runtime path

    TREE                            REMARKS ~

    filetype.vim                    filetypes by filename, see `:h new-filetype`
    scripts.vim                     filetypes by contents, see `:h new-filetype-scripts`
?   ftplugin.vim
?   indent.vim
?   after
        indent
            {filetype}.vim
        plugin
            {name}.vim
        syntax
            {filetype}.vim
        ftplugin
            {filetype}.vim
        *                           all else ignored
    autoload                        automatic-loaded scripts, see `:h autoload-functions`
        {name}.vim
    colors                          colorscheme files, see `:h colorscheme`
        {colorscheme}.vim
    ftdetect
        {name}.vim                  see `:h ftdetect`
    ftplugin                        filetype plugins, see `:h write-filetype-plugin`
        {filetype}.vim
    import                          files found by `:import`
    indent                          indent scripts, see `:h indent-expression`
        {filetype}.vim
    pack
        {package}                   package name
            opt                     optionally loaded, see `:h packadd`
            start                   always loaded, see `:h packloadall`
                {plugin}            plugin name
                    autoload
                    doc
                    ftplugin
                    plugin
    plugin                          plugins, see `:h write-plugin`
        {plugin}
            {*}.vim
    syntax                          syntax files, see `:h syntax-loading`
        {filetype}.vim

    $VIMRUNTIME
        indent.vim                  :au FileType * runtime! indent/{filetype}.vim
        ftplugin.vim                :au FileType * runtime! ftplugin/{filetype}.vim
        indent
            {filetype}.vim
        syntax
            syntax.vim
            syncolor.vim            :au FileType * set syntax={filetype}
                                    :doautoall FileType
            synload.vim             :runtime! syntax/{filetype}.vim
                                    :runtime! syntax/{filetype}/*.vim


=========================================================================================
3. Environment

    VAR                         MEANING ~

    VIM                         /usr/local/share/vim
    MYVIMRC                     $HOME/.vimrc
    VIMRUNTIME                  /usr/local/share/vim/vim91

=========================================================================================
4. Sourcing files

    COMMAND                     MEANING ~

    :runtime        {file}      Source first {file} found in 'rtp'
    :runtime!       {file}      Source all {file}s found in 'rtp'
    :runtime  START {file}      Search only under "start" in 'pp'
    :runtime  OPT   {file}      Search only under "opt" in 'pp'
    :runtime  PACK  {file}      Search under "start" and "opt" in 'pp'
    :runtime  ALL   {file}      Search 'rtp', then "start" and "opt" in 'pp'

    :source         {file}      Read Ex commands from {file}
    :source!        {file}      Read vim (ie, Normal mode) commands from {file}

    :packadd
    :packadd!
    :packloadall                Load all packages under "start" in 'pp'
                                 -  Add 'pp' `pack/*/start/*` dirs to 'rtp'
                                 -  Source 'pp' `pack/*/start/*/plugin/*``
    :packloadall!


=========================================================================================
5. Settings

    SETTING                     MEANING ~

    'runtimepath'               Default:
                                    `$HOME/.vim`
                                    `$VIM/vimfiles`
                                    `$VIMRUNTIME`
                                    `$VIM/vimfiles/after`
                                    `$HOME/.vim/after`
    'packpath'
    'syntax'


=========================================================================================
6. File type

    COMMAND                     MEANING ~

    :filetype
    :filetype on                :runtime! filetype.vim
?                               :runtime! ftdetect/*.vim
    :filetype detect
    :filetype plugin on         :runtime! ftplugin.vim
    :filetype indent on         :runtime! indent.vim

    :setfiletype {filetype}
    :set filetype={filetype}

=========================================================================================
7. Syntax

    COMMAND                     MEANING~

    :syntax on                  :source $VIMRUNTIME/syntax/syntax.vim
    :syntax off                 :source $VIMRUNTIME/syntax/nosyntax.vim
    :syntax enable              :source $VIMRUNTIME/syntax/syntax.vim
                                    :source $VIMRUNTIME/syntax/synload.vim
                                :source $VIMRUNTIME/syntax/syncolor.vim

=========================================================================================
8. Color

    COMMAND                     MEANING ~

    :colorscheme {name}         :source $VIMRUNTIME/colors/lists/default.vim
                                ColorSchemePre
                                :runtime ALL colors/{name}.vim
                                ColorScheme

 vim:tw=89:ft=help

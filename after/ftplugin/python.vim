" Usage
"   :make %         Runs mypy on current file
"   :make <dir/>    Runs mypy on all files in <dir/>
"   :make <file>    Runs mypy on <file>
setlocal makeprg=$HOME/.pytools/bin/mypy\ $*

call utils#set_undo_ftplugin('setlocal mp<')

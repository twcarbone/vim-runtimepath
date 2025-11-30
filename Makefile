.PHONY: install ycm thirdparty fzf

install:
	rm -rf $$HOME/.vim
	ln -s $$PWD $$HOME/.vim
	git submodule update --init --recursive
	$(MAKE) ycm
	$(MAKE) fzf

ycm:
	python3 pack/thirdparty/start/vim-ycm/install.py --clangd-completer

thirdparty:
	mkdir -p $$HOME/devl/thirdparty

fzf: thirdparty
	rm -rf $$HOME/devl/thirdparty/fzf
	git clone git@github.com:junegunn/fzf.git $$HOME/devl/thirdparty/fzf
	$$HOME/devl/thirdparty/fzf/install --key-bindings --completion --no-update-rc
	ln -s $$HOME/devl/thirdparty/fzf/plugin/fzf.vim plugin/fzf.vim

test:
	@cd testdir && $(MAKE) --no-print-directory

.PHONY: install vim-ycm

install:
	rm -f $$HOME/.vim
	ln -s $$PWD $$HOME/.vim
	git submodule update --init --recursive
	$(MAKE) vim-ycm

vim-ycm:
	python3 pack/thirdparty/start/$@/install.py --clangd-completer

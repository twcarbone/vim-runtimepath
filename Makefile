.PHONY: install ycm thirdparty fzf

THIRDPARTY	= $$HOME/devl/thirdparty

install:
	rm -rf $$HOME/.vim
	ln -s $$PWD $$HOME/.vim
	git submodule update --init --recursive
	$(MAKE) vim
	$(MAKE) ycm
	$(MAKE) fzf
	$(MAKE) docs

.PHONY: vim

VIM_VERSION	= v9.1.0698
VIM_CONFIG	= --disable-gui --enable-python3interp --with-python3-command=python3

vim: thirdparty
	git clone --depth=1 --branch=$(VIM_VERSION) git@github.com:vim/vim.git $(THIRDPARTY)/vim
	cd $(THIRDPARTY)/vim/src && $(MAKE) distclean && ./configure $(VIM_CONFIG) && $(MAKE) -j
	cd $(THIRDPARTY)/vim/src && sudo $(MAKE) install

docs:
	find pack/*/*/*/doc -type d -name doc -exec vim --clean -c "helptags {}" -c "q" \;

ycm:
	python3 pack/thirdparty/start/vim-ycm/install.py --clangd-completer

thirdparty:
	mkdir -p $$HOME/devl/thirdparty

fzf: thirdparty
	rm -rf $$HOME/devl/thirdparty/fzf
	git clone git@github.com:junegunn/fzf.git $$HOME/devl/thirdparty/fzf
	$$HOME/devl/thirdparty/fzf/install --key-bindings --completion --no-update-rc
	ln -s $$HOME/devl/thirdparty/fzf/plugin/fzf.vim plugin/fzf.vim

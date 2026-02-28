THIRDPARTY	= $$HOME/devl/thirdparty


.PHONY: install
install:
	rm -rf $$HOME/.vim
	ln -s $$PWD $$HOME/.vim
	git submodule update --init --recursive
	$(MAKE) vim
	$(MAKE) ycm
	$(MAKE) fzf
	$(MAKE) docs


.PHONY: thirdparty
thirdparty:
	mkdir -p $(THIRDPARTY)


.PHONY: vim

VIM_VERSION			= v9.1.0698
VIM_CLONE_FLAGS		= --depth=1 --branch=$(VIM_VERSION) 
VIM_CONFIG_FLAGS	= --disable-gui --enable-python3interp --with-python3-command=python3

vim: thirdparty
	rm -rf $(THIRDPARTY)/vim
	git clone $(VIM_CLONE_FLAGS) git@github.com:vim/vim.git $(THIRDPARTY)/vim
	cd $(THIRDPARTY)/vim/src && ./configure $(VIM_CONFIG_FLAGS) && $(MAKE)
	cd $(THIRDPARTY)/vim/src && sudo $(MAKE) install


.PHONY: docs
docs:
	find pack/*/*/*/doc -type d -name doc -exec vim --clean -c "helptags {}" -c "q" \;


.PHONY: ycm
ycm:
	python3 pack/thirdparty/start/vim-ycm/install.py --clangd-completer


.PHONY: fzf

FZF_INSTALL_FLAGS	= --key-bindings --completion --no-update-rc

fzf: thirdparty
	rm -rf $(THIRDPARTY)/fzf
	git clone git@github.com:junegunn/fzf.git $(THIRDPARTY)/fzf
	$(THIRDPARTY)/fzf/install $(FZF_INSTALL_FLAGS)
	ln -sf $(THIRDPARTY)/fzf/plugin/fzf.vim plugin/fzf.vim

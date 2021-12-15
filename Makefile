SYMLINK := ln -sf
CP := cp

.PHONY: dummy
dummy:
	@ echo 'If you want to install dotfiles, run'
	@ echo '	make install'

dotfiles_root:
	@ echo 'GEN	dotfiles_root'
	@ echo $(CURDIR) >dotfiles_root

.PHONY: install-w32
install-w32: dotfiles_root
	@ echo 'CP	.dotfiles_root'
	@ $(CP) $< $(HOME)/.dotfiles_root

.PHONY: install

ifdef MSYSTEM
install: install-w32
endif

install:
	@ echo 'LN	.bashrc'
	@ $(SYMLINK) $(CURDIR)/bash/bashrc $(HOME)/.bashrc
	@ echo 'LN	.bash_profile'
	@ $(SYMLINK) $(CURDIR)/bash/bash_profile $(HOME)/.bash_profile
	@ echo 'LN	.bash_logout'
	@ $(SYMLINK) $(CURDIR)/bash/bash_logout $(HOME)/.bash_logout
	@ echo 'LN	.vimrc'
	@ $(SYMLINK) $(CURDIR)/vim/vimrc $(HOME)/.vimrc
	@ echo 'LN	.clang-format'
	@ $(SYMLINK) $(CURDIR)/clang-tools/clang-format $(HOME)/.clang-format
	@ echo 'LN	.aspell.conf'
	@ $(SYMLINK) $(CURDIR)/misc/aspell.conf $(HOME)/.aspell.conf
	@ echo 'LN	.inputrc'
	@ $(SYMLINK) $(CURDIR)/misc/inputrc $(HOME)/.inputrc
	@ echo 'LN	.screenrc'
	@ $(SYMLINK) $(CURDIR)/misc/screenrc $(HOME)/.screenrc
	@ echo 'LN	.zshrc'
	@ $(SYMLINK) $(CURDIR)/zsh/zshrc.zsh $(HOME)/.zshrc

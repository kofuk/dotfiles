SYMLINK := ln -sf

.PHONY: dummy
dummy:
	@ echo 'If you want to install dotfiles, run'
	@ echo '	make install'

.PHONY: install
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
	@ echo 'LN	compile_flags.txt'
	@ $(SYMLINK) $(CURDIR)/clang-tools/compile_flags.txt $(HOME)/compile_flags.txt
	@ echo 'LN	.aspell.conf'
	@ $(SYMLINK) $(CURDIR)/misc/aspell.conf $(HOME)/.aspell.conf
	@ echo 'LN	.inputrc'
	@ $(SYMLINK) $(CURDIR)/misc/inputrc $(HOME)/.inputrc
	@ echo 'LN	.screenrc'
	@ $(SYMLINK) $(CURDIR)/misc/screenrc $(HOME)/.screenrc
	@ echo 'LN	.zshrc'
	@ $(SYMLINK) $(CURDIR)/zsh/zshrc.zsh $(HOME)/.zshrc

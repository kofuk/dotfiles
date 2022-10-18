SYMLINK := ln -sf
CP := cp

.PHONY: help
help:
	@ echo 'If you want to install dotfiles, run'
	@ echo '	make install'
	@ echo 'or, you can install these targets separately:'
	@ echo '	bashrc				.bashrc'
	@ echo '	bash_profile		.bash_profile'
	@ echo '	bash_profile		.bash_profile'
	@ echo '	bash_logout		.bash_logout'
	@ echo '	vimrc				.vimrc'
	@ echo '	clang-format		.clang-format'
	@ echo '	aspell-conf		.aspell.conf'
	@ echo '	inputrc			.inputrc'
	@ echo '	tmux-conf			.tmux.conf'
	@ echo '	zshrc				.zshrc'
	@ echo '	install_minimal	Installs only Bash-related files'

dotfiles_root:
	@ echo 'GEN	dotfiles_root'
	@ echo $(CURDIR) >dotfiles_root

.PHONY: install-w32
install-w32: dotfiles_root
	@ echo 'CP	.dotfiles_root'
	@ $(CP) $< $(HOME)/.dotfiles_root

.PHONY: bashrc
bashrc:
	@ echo 'LN	.bashrc'
	@ $(SYMLINK) $(CURDIR)/bash/bashrc $(HOME)/.bashrc

.PHONY: bash_profile
bash_profile:
	@ echo 'LN	.bash_profile'
	@ $(SYMLINK) $(CURDIR)/bash/bash_profile $(HOME)/.bash_profile

.PHONY: bash_logout
bash_logout:
	@ echo 'LN	.bash_logout'
	@ $(SYMLINK) $(CURDIR)/bash/bash_logout $(HOME)/.bash_logout

.PHONY: vimrc
vimrc:
	@ echo 'DL	vim-plug'
	curl -Lo $(HOME)/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@ echo 'LN	.vimrc'
	@ $(SYMLINK) $(CURDIR)/vim/vimrc $(HOME)/.vimrc

.PHONY: clang-format
clang-format:
	@ echo 'LN	.clang-format'
	@ $(SYMLINK) $(CURDIR)/clang-tools/clang-format $(HOME)/.clang-format

.PHONY: aspell-conf
aspell-conf:
	@ echo 'LN	.aspell.conf'
	@ $(SYMLINK) $(CURDIR)/misc/aspell.conf $(HOME)/.aspell.conf

.PHONY: inputrc
inputrc:
	@ echo 'LN	.inputrc'
	@ $(SYMLINK) $(CURDIR)/misc/inputrc $(HOME)/.inputrc

.PHONY: tmux-conf
tmux-conf:
	@ echo 'LN	.tmux.conf'
	@ $(SYMLINK) $(CURDIR)/misc/tmux.conf $(HOME)/.tmux.conf

.PHONY: zshrc
	@ echo 'LN	.zshrc'
	@ $(SYMLINK) $(CURDIR)/zsh/zshrc.zsh $(HOME)/.zshrc

.PHONY: install
.PHONY: install_minimal

ifdef MSYSTEM
install: install-w32
install_minimal: install-w32
endif

install: bashrc bash_profile bash_logout vimrc clang-format aspell-conf inputrc tmux-conf zshrc

install_minimal: bashrc bash_profile bash_logout inputrc

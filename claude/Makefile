SYMLINK := ln -sf
MKDIR := mkdir -p

.PHONY: install
install:
	$(MKDIR) $(HOME)/.claude
	$(SYMLINK) $(CURDIR)/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	$(SYMLINK) $(CURDIR)/settings.json $(HOME)/.claude/settings.json
	$(SYMLINK) $(CURDIR)/statusline.sh $(HOME)/.claude/statusline.sh

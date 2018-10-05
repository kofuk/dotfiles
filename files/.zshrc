# Set up the prompt
if command -v npm &>/dev/null && npm ls -g pure-prompt &>/dev/null; then
    # Nodejs' prefix must be set to ~/.npm_global
    fpath+=("$HOME/.npm_global/lib/node_modules/pure-prompt/functions")
    autoload -Uz promptinit; promptinit
    prompt pure
else
    autoload -Uz promptinit; promptinit
    prompt adam1
fi

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignorealldups histignorespace histreduceblanks histnostore \
    histsavenodups sharehistory histverify

function _addhisthook() {
    local cmd=${1%% *}
    if ! command -v "$cmd" &>/dev/null; then
        return 1
    fi
    ! [[ $cmd =~ "(exit|cd|l[as]|\\.\\.)" ]]
}

add-zsh-hook zshaddhistory _addhisthook

autoload -U select-word-style
select-word-style bash

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enable and load Auto cd configuration if it exists.
if [ -f "$HOME/.autocds" ]; then
    setopt autocd
    source "$HOME/.autocds"
fi

# notify when background job finishes
setopt notify

# Detect typo and suggest correct command
setopt correct

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
alias grep='grep --color=auto'
alias ..='cd ..'
if command -v crontab &>/dev/null; then
    alias crontab='crontab -i'
fi
alias rm='rm -i'

# Aliases of Git
alias got='git status'
alias gitgraph='git log --graph --decorate=full --all --date=iso --pretty="%C(yellow)%h%C(reset) %s %C(cyan)by %an%C(reset) %C(auto)%d%C(reset)%n%x09%C(blue)[%ad]%C(reset)"'

if command -v vim &>/dev/null; then
    export EDITOR=vim
fi

# Path
## User's private bin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
## Golang
if [ -d /usr/local/golang ]; then
    PATH="/usr/local/golang:$PATH"
fi
if [ -d "$HOME/go/bin" ]; then
    PATH="$PATH:$HOME/go/bin"
fi
## Android SDK
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    PATH="$HOME/Android/Sdk/platform-tools:$PATH"

    # Force Android emulator to use system built-in library
    export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
fi
## Flutter
if [ -d /usr/local/flutter ]; then
    PATH=/usr/local/flutter/bin:$PATH
fi
# Node.js
if [ -d "$HOME/npm_global/bin" ]; then
    PATH=$HOME/npm_global/bin:$PATH
fi

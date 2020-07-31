# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# aliases
alias rm='rm -i'
alias em='emacs'
alias ssh='ssh -o VisualHostKey=yes'
alias make='time make'
alias dmake='cmake -DCMAKE_INSTALL_PREFIX="$HOME" -DCMAKE_BUILD_TYPE=Debug'
alias ctest='ctest --verbose'
alias ccopy='xclip -selection clipboard'
alias cpaste='xclip -selection clipboard -o'
alias diff='diff -u --color=auto'
alias open='xdg-open'
alias gitgraph='git log --graph --decorate=full --all --date=iso --pretty="%C(yellow)%h%C(reset) %s %C(cyan)by %an%C(reset) %C(auto)%d%C(reset)%n%x09%C(blue)[%ad]%C(reset)"'
alias platex='platex -halt-on-error'
alias uplatex='uplatex -halt-on-error'

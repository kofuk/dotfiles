# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias em='emacs'
alias ssh='ssh -o VisualHostKey=yes'
alias dmake='cmake -DCMAKE_INSTALL_PREFIX:PATH="$HOME" -DCMAKE_BUILD_TYPE:STRING=Debug'
alias ctest='ctest --verbose'
if command -v xsel &>/dev/null; then
    alias ccopy='xsel -ib'
    alias cpaste='xsel -ob'
elif command -v termux-clipboard-set &>/dev/null; then
    alias ccopy='termux-clipboard-set'
    alias cpaste='termux-clipboard-get'
else
    alias ccopy='xclip -selection clipboard'
    alias cpaste='xclip -selection clipboard -o'
fi
if diff --color=auto /dev/null /dev/null &>/dev/null; then
    alias diff='diff -u --color=auto'
else
    function diff() {
        if [ -t 1 ]; then
            command diff -u "$@" | sed -E 's/^(---|\+\+\+)/'$'\033''[1m&/g;s/^@@/'$'\033''[36m&/g;s/^-/'$'\033''[31m&/g;s/^\+/'$'\033''[32m&/g;s/$/'$'\033''[0m/g'
        else
            command diff -u "$@"
        fi
    }
fi
alias open='xdg-open'
alias gitgraph='git log --graph --decorate=full --all --date=iso --pretty="%C(yellow)%h%C(reset) %s %C(cyan)by %an%C(reset) %C(auto)%d%C(reset)%n%x09%C(blue)[%ad]%C(reset)"'
alias platex='platex -halt-on-error'
alias uplatex='uplatex -halt-on-error'
alias lualatex='lualatex -halt-on-error'
alias rrn='rr record -n'
alias rrr='rr replay'
alias rrrr='rr replay'
alias rrrrr='rr replay'
alias rrrrrr='rr replay'
alias rrrrrrr='rr replay'
alias cr='cargo run -j$(nproc) --'
# Disable persisted history on Node.js
alias node='env NODE_REPL_HISTORY= node'
alias 意識高いやつ="sed -i 'y/、。/，．/' --"
alias unzipipe='/usr/lib/jvm/java-11-openjdk/bin/jar x'
alias quoted="awk '/^>/ {printf \">%s\n\", \$0} !/^>/ {printf \"> %s\n\", \$0}'"

# Defines wrapper function for 'time make' instead of aliasing it.
# Aliasing it causes an error if called with the following form:
#     SOME_VAR=value make
# This is because time is shell's keyword and should be placed to
# the beginning of line (according to bash(1)->SHELL GRAMMAR->Pipelines),
# but the alias causes shell to expand the command line to the following form:
#     SOME_VAR=value time make
# despite that
#     time SOME_VAR=value make
# is correct.
function make() {
    # omitting `command' causes infinite recursive call (though it is no wonder.)
    time command make "$@"
}

# Try to attach existing tmux session unless any arguments supplied.
function tmux() {
    if [ $# -eq 0 ]; then
        command tmux new-session -As0
    else
        command tmux "$@"
    fi
}

function cd() {
    if [ $# -eq 1 ] && [[ "$1" =~ ^: ]] && git rev-parse --is-inside-work-tree &>/dev/null; then
        [[ "$1" =~ ^:/ ]] && builtin cd "$(git rev-parse --show-toplevel)/${1##:/}" || builtin cd "${1##:}"
        return
    fi
    builtin cd "$@"
}

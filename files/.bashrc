# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if [ -z "$SSH_CLIENT" ]; then
    host=
else
    host='@\h'
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    PS1="\[\033[01;32m\]\u$host\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "
else
    PS1="\u$host:\w\$ "
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;\u$h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

unset host

function __exit_code_prompt() {
    local last_exit="$?"
    local message
    if [ "$last_exit" -eq 0 ]; then
        echo -en '\e[38;5;14m'
        message='success'
    else
        echo -en '\e[38;5;13m'
        message="failure ($last_exit)"
    fi
    if [ "$last_exit" -gt 128 ]; then
        local signum="$((last_exit-128))"
        local signal="$(kill -l "$signum" 2>/dev/null)"
        if [ -z "$signal" ]; then
            signal='unknown signal'
        else
            signal="SIG$signal"
        fi
        message="failure ($last_exit/$signal)"
    fi
    echo -n "//=> $message"
    echo -e '\e[0m'
}

PROMPT_COMMAND=__exit_code_prompt
PROMPT_DIRTRIM=5

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# aliases
alias rm='rm -i'
alias emacs='emacsclient -c -a ""'
alias em='emacs'
alias ssh='ssh -o VisualHostKey=yes'
alias make='time make'
alias dmake='cmake -DCMAKE_INSTALL_PREFIX="$HOME" -DCMAKE_BUILD_TYPE=Debug'
alias cbcopy='xclip -selection clipboard'
alias cbpaste='xclip -selection clipboard -o'
alias diff='diff -u --color=auto'
alias open='xdg-open'
alias gitgraph='git log --graph --decorate=full --all --date=iso --pretty="%C(yellow)%h%C(reset) %s %C(cyan)by %an%C(reset) %C(auto)%d%C(reset)%n%x09%C(blue)[%ad]%C(reset)"'
alias uplatex='uplatex -halt-on-error'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Though I mainly use Emacs, specify Vim here to use it on light work.
export EDITOR=vim

# Utilities
function gengif() {
    local user_id="$(id -ur)"
    local palettepath="/tmp/palette-$user_id-$RANDOM.png"
    ffmpeg -i "$1" -vf palettegen "$palettepath" & \
        ffmpeg -i "$1" -i "$palettepath" -filter_complex paletteuse out.gif
        rm -f "$palettepath"
}

function screenrecord() {
    if [ "$XDG_SESSION_TYPE" != "x11" ]; then
        echo 'Must run in Xorg session.'
        return 1
    fi

    local dimen="$(xdpyinfo | grep dimensions | head -n 1 | awk '{print $2}')"
    if [ -z "$dimen" ]; then
        echo 'Cannot retrive screen dimension.'
        return 1
    fi

    if [ $# -eq 0 ]; then
        echo 'screenrecord: fatal: Must specify output filename.'
        return 1;
    elif [ $# -ge 1 ]; then
        if [ "$1" = '--help' ]; then
            echo 'Usage: screenrecord [--with-audio] OUTNAME'
            return 0
        elif [ "$1" = '--with-audio' ]; then
            if [ $# -ge 2 ]; then
                ffmpeg -video_size "$dimen" -framerate 25 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default "$2"
            else
                echo 'Must specify output filename.'
                return 1
            fi
        else
            ffmpeg -video_size "$dimen" -framerate 25 -f x11grab -i :0.0+0,0 "$1"
            return 1
        fi
    fi
}

function tex2pdf() {
    if [ ! $# -eq 1 ]; then
        echo 'Please specify a texname' >&2
        return 1
    fi
    uplatex "$1" && dvipdfmx "${1%.tex}.dvi"
}

function texclean() {
    rm -f *.aux *.dvi *.log *.toc
}

function texwatch() {
    if [ "$#" -lt 1 ]; then
        echo 'texname required.' >&2
        return 1
    fi
    local filename="$1"
    if ! echo "$filename" | grep '\.tex$' &>/dev/null; then
        filename="$filename.tex"
    fi
    inotifywait -meclose_write -- "$filename" | while read; do
        tex2pdf "$filename" || echo -e '\e[37;41m              TeX COMPILATION FAILED!              \e[0m';
    done
}

function tofu() {
    if [ "$#" -ne 1 ]; then
        echo 'usage: tofu FILE' >&2
        return 1
    fi
    local enc="$(uchardet "$1")"
    if [ "$enc" = 'unknown' ]; then
        echo 'Unable to determine original encoding'
        return 1
    fi
    uconv -f "$enc" "$1"
}

# Set secret environment variables, namely api keys and so on
if [ -e "$HOME/.secret.env" ]; then
    . "$HOME/.secret.env"
fi

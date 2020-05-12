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
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -z "$SSH_CLIENT" ]; then
    host=
else
    host='@\h'
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[\033[01;32m\]\u$host\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "
else
    PS1="\u$host:\w\$ "
fi
unset color_prompt force_color_prompt

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
    if [ "$last_exit" -eq 0 ]; then
        echo -en '\e[38;5;14m'
    else
        echo -en '\e[38;5;13m'
    fi
    echo -n "=>[$last_exit]"
    echo -e '\e[0m'
}

export PROMPT_COMMAND=__exit_code_prompt

export PROMPT_DIRTRIM=5

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
fi

alias rm='rm -i'
if command -v emacs &>/dev/null; then
    alias emacs='emacsclient -c -a ""'
    alias em='emacs'
fi

alias ssh='ssh -o VisualHostKey=yes'

if command -v make &>/dev/null; then
    alias make='time make'
fi

if command -v cmake &>/dev/null; then
    alias dmake='cmake -DCMAKE_INSTALL_PREFIX="$HOME" -DCMAKE_BUILD_TYPE=Debug'
fi

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
if command -v ffmpeg &>/dev/null; then
    function gengif() {
        local palettepath="/tmp/palette_$RANDOM.png"
        ffmpeg -i "$1" -vf palettegen "$palettepath"
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
fi

if command -v uplatex > /dev/null && command -v dvipdfmx > /dev/null; then
    function tex2pdf() {
        if [ ! $# -eq 1 ]; then
            echo 'Please specify a texname' >&2
            exit 1
        fi
        uplatex "$1" && dvipdfmx "${1%.tex}.dvi"
    }
fi

if [ -e "$HOME/.bashrc-local" ]; then
    . "$HOME/.bashrc-local"
fi

if command -v git >/dev/null; then
    alias gitgraph='git log --graph --decorate=full --all --date=iso --pretty="%C(yellow)%h%C(reset) %s %C(cyan)by %an%C(reset) %C(auto)%d%C(reset)%n%x09%C(blue)[%ad]%C(reset)"'
fi

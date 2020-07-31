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

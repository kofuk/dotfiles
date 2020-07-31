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

__dirname_orig="$__dirname"
__dirname="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE:-$0}")")"; pwd)"
PROMPT_COMMAND="$(cat "$__dirname/exit_status_prompt.bash")"
if [ -z "$__dirname_orig" ]; then
    unset __dirname_orig __dirname
else
    __dirname="$__dirname_orig"
    unset __dirname_orig
fi

PROMPT_DIRTRIM=5

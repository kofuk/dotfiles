function __construct_prompt() {
    local color_prompt host cwd='\w' user='\u'
    # color escape sequences
    local color_reset color_green color_blue

    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac

    if [[ "$color_prompt" = 'yes' ]]; then
        color_reset='\e[0m'
        color_green='\e[1;32m'
        color_blue='\e[1;34m'
    fi

    [ -z "$SSH_CLIENT" ] || host='@\h'

    PS1="$color_green$user$host$color_reset:$color_blue$cwd$color_reset\$ "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\e]0;\u$h: \w\a\]$PS1"
            ;;
        *)
            ;;
    esac

    # show exit status of previous command.
    local dirname="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE:-$0}")")"; pwd)"
    PROMPT_COMMAND="$(cat "$dirname/exit_status_prompt.bash")"
} && __construct_prompt; unset __construct_prompt

PROMPT_DIRTRIM=5

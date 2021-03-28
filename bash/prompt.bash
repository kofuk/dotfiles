function __construct_prompt() {
    local color_prompt host cwd='\w' user='\u'
    # color escape sequences
    local color_reset color_green color_blue color_ssh_tag

    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac

    if [[ "$color_prompt" = 'yes' ]]; then
        color_reset='\[\033[0m\]'
        color_green='\[\033[1;32m\]'
        color_blue='\[\033[1;34m\]'
        color_ssh_tag='\[\033[1;37;44m\]'
    fi

    if [ ! -z "$SSH_CLIENT" ]; then
        _PS1="$color_ssh_tag SSH $color_reset "
        host='@\h'
    else
        # Fresh start
        _PS1=
    fi

    # Placeholder for exit status
    _PS1="$_PS1@@"

    _PS1="$_PS1$color_green$user$host$color_reset:$color_blue$cwd$color_reset\\\$ "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
            _PS1="$_PS1\[\033]0;\u$h: \w\a\]"
            ;;
        *)
            ;;
    esac

    # PROMPT_COMMAND sets PS1

    # show exit status of previous command.
    PROMPT_COMMAND="$(cat "$_DOTFILES_BASH_ROOT/exit_status_prompt.bash")"
} && __construct_prompt; unset __construct_prompt

PROMPT_DIRTRIM=5

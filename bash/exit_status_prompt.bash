# Saves $? first to avoid being overritten by other commands.
_prompt_last_exit="$?"
function __exit_status_prompt() {
    local message signal color_prompt color_ok color_err color_reset
    case "${TERM}" in
        xterm-color|*-256color)
            color_prompt=yes
            color_ok='\[\033[38;5;12;1m\]'
            color_err='\[\033[38;5;9;1m\]'
            color_reset='\[\033[0m\]'
            ;;
    esac

    if [ "${_prompt_last_exit}" -eq 0 ]; then
        local sign
        if [ ! -z "${SSH_CONNECTION}" ] || [ "${XDG_SESSION_TYPE}" = 'tty' ]; then
            sign='OK'
        else
            sign='✓'
        fi
        message="${color_ok}${sign}${color_reset}"
    elif [ "${_prompt_last_exit}" -gt 128 ] && \
             kill -l "$((${_prompt_last_exit-128}))" &>/dev/null; then
        message="${color_err}$(kill -l "$((_prompt_last_exit-128))")${color_reset}"
    else
        message="${color_err}${_prompt_last_exit}${color_reset}"
    fi

    # Rewriting PS1 because echo-ing in the PROMPT_COMMAND breaks readline.
    PS1="${_PS1/@@/$message }"

    if [ ! -z "${_PROMPT_FIRST_EXEC}" ]; then
        unset _PROMPT_FIRST_EXEC
    else
        if [ "${color_prompt}" = yes ] && [ "${TERM}" != 'dumb' ]; then
            if [ -z "${INSIDE_EMACS}" ] || [ "${INSIDE_EMACS}" = 'vterm' ]; then
                # https:/zenn.dev/mattn/articles/b4d56356f42453
                # TODO: Don't evaluate if no command executed previously.
                local cursor_pos
                echo -en '\033[6n' && read -sdR cursor_pos
                [ ! -z "${FIG_JETBRAINS_SHELL_INTEGRATION}" ] && read -sdR cursor_pos
                if [ "$(cut -d\; -f2 <<<"${cursor_pos}")" -gt 1 ]; then
                    echo -e '\033[7;1m%\033[0m'
                else
                    echo -e '\033[A'
                fi
            fi
        fi
    fi
} && __exit_status_prompt; unset __exit_status_prompt
unset _prompt_last_exit

# Saves $? first to avoid being overritten by other commands.
_prompt_last_exit="$?"
function __exit_status_prompt() {
    local message signal

    if [ "$_prompt_last_exit" -eq 0 ]; then
        echo -en '\e[38;5;14m'
        message='success'
    else
        echo -en '\e[38;5;13m'
        message="failure ($_prompt_last_exit)"
    fi

    # Although some exceptions exist, exit status greater than 128 indicates
    # signaled termination of the process, and its signal is (status code) - 128.
    if [ "$_prompt_last_exit" -gt 128 ]; then
        # `kill -l SIGNUM` prints signal name, like INT or TERM.
        signal="$(kill -l "$((_prompt_last_exit-128))" 2>/dev/null)"

        message="failure ($_prompt_last_exit/${signal:-unknown signal})"
    fi

    echo -n "//=> $message"
    echo -e '\e[0m'
} && __exit_status_prompt; unset __exit_status_prompt

unset _prompt_last_exit

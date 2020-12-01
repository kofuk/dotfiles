# Saves $? first to avoid being overritten by other commands.
_prompt_last_exit="$?"
function __exit_status_prompt() {
    local message signal

    if [ "$_prompt_last_exit" -eq 0 ]; then
        message='[\e[38;5;12;1m✓\e[0m]'
    elif [ "$_prompt_last_exit" -gt 128 ] && \
             kill -l "$(($_prompt_last_exit-128))" &>/dev/null; then
        message="[\\e[38;5;9;1m$(kill -l "$(($_prompt_last_exit-128))")\\e[0m]"
    else
        message="[\\e[38;5;9;1m$_prompt_last_exit\\e[0m]"
    fi

    # Rewriting PS1 because echo-ing in the PROMPT_COMMAND may break readline, dunno.
    PS1="${PS1/\\\[\[*\]\\\]/\\[$message\\]}"
} && __exit_status_prompt; unset __exit_status_prompt

unset _prompt_last_exit

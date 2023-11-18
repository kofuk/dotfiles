export FZF_DEFAULT_OPTS='--height 40%'

__K_history() {
    READLINE_LINE="$(builtin fc -lnr -10000000 | sed 's/^\t //' | fzf --bind=ctrl-z:ignore)"
    READLINE_POINT=0x7fffffff
}
bind -x '"\C-r": __K_history'

__K_complete_file() {
    local output
    output="$(fzf -m | sed -E "s/'/'\\\\''/; s/^.*$/'&'/" | tr \\n ' ')"
    READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}${output}${READLINE_LINE:READLINE_POINT}"
    (( READLINE_POINT += ${#output} ))
}
bind -x '"\C-y": __K_complete_file'

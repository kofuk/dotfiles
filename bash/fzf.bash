export FZF_DEFAULT_OPTS='--height 40% --cycle --bind=ctrl-z:ignore --no-unicode --marker="*" --color=dark,info:bright-cyan,prompt:cyan:bold,pointer:white,marker:white:bold'

__K_history() {
    READLINE_LINE="$(builtin fc -lnr -10000000 | sed 's/^\t //' | fzf)"
    READLINE_POINT=0x7fffffff
}
bind -x '"\C-r": __K_history'

__K_complete_file() {
    local output
    output="$(fzf --multi | sed -E "s/'/'\\\\''/; s/^.*$/'&'/" | tr \\n ' ')"
    READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}${output}${READLINE_LINE:READLINE_POINT}"
    (( READLINE_POINT += ${#output} ))
}
bind -x '"\C-y": __K_complete_file'

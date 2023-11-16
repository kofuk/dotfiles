__K_history() {
    local output
    READLINE_LINE="$(builtin fc -lnr -10000000 | sed 's/^\t //' | fzf --height 40% --bind=ctrl-z:ignore)"
    READLINE_POINT=0x7fffffff
}

bind -x '"\C-r": "__K_history"'

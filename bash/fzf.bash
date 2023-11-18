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

Menu() {
    local additional_items
    if [ -e "${HOME}/.config/shmenu/menu.txt" ]; then
        additional_items+=( "${HOME}/.config/shmenu/global.txt" )
    fi
    if [ -e .shmenu.txt ]; then
        additional_items+=( '.shmenu.txt' )
    fi
    local cmd
    cmd=$(
        set -o pipefail
        cat - "${additional_items[@]}" <<'EOF' | fzf --with-nth 2.. | cut -d ' ' -f1
__K_docker_kill docker | Kill Containers
__K_git_switch git    | Switch Branch
__K_git_branch_del git    | Delete Local Branch
__K_repo misc   | Change Directory to a Repository
EOF
       ) || return

    "${cmd}"
}
# We can't use `bind -x` because it forks.
bind '"\C-@": "\C-e\C-u Menu\n"'

__K_docker_kill() {
    local containers
    containers=(
        $(
            set -o pipefail
            docker ps -a --format '{{ .ID }}' |
                fzf --multi --preview 'docker ps -af id={} --format "Image: {{ .Image }}\nCommand: {{ .Command }}\nCreated: {{ .CreatedAt }}\nStatus: {{ .Status }}"' |
                cut -d ' ' -f1
        )
    ) || return
    docker kill -- "${containers[@]}"
}

__K_git_branch_del() {
    local ref
    refs=(
        $(
            set -o pipefail
            git for-each-ref --format='%(refname:strip=2)' 'refs/heads/*' 'refs/heads/*/**' |
                fzf --multi
        )
    ) || return
    git branch -D "${refs[@]}"
}

__K_git_switch() {
    local ref
    ref=$(
        set -o pipefail
        {
            git for-each-ref --format='%(refname:strip=2)' 'refs/heads/*' 'refs/heads/*/**'
            git for-each-ref --format='%(refname:strip=3)' 'refs/remotes/*' 'refs/remotes/*/**'
        } | fzf) || return
    git switch -- "${ref}"
}

__K_repo() {
    local dir=$(
        ls ~/source |
            fzf --preview 'shopt -s nullglob; cat "${HOME}"/source/{}/README*' |
            sed "s@^@${HOME}/source/@") || return
    cd -- "${dir}"
}

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
    [ -e "${HOME}/.config/shmenu/menu.txt" ] && additional_items+=( "${HOME}/.config/shmenu/menu.txt" )
    [ -e "${HOME}/.config/shmenu/prehook.sh" ] && . "${HOME}/.config/shmenu/prehook.sh"

    local cmd
    cmd=$(
        set -o pipefail
        local filter_menu_pl="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/filter_menu.pl"
        cat - "${additional_items[@]}" <<'EOF' | grep -v '^#' | perl -p "${filter_menu_pl}" | grep -v '\[HIDDEN\]' | fzf --with-nth 2.. | cut -d ' ' -f1
__K_docker_kill    docker | Kill Containers
__K_docker_rm      docker | Remove Containers
__K_docker_rmi     docker | Remove Images
__K_git_switch     git    | Switch Branch {<.git}
__K_git_branch_del git    | Delete Local Branch {<.git}
__K_repo           misc   | Change Directory to a Repository
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
            docker ps -aq |
                fzf --multi --preview 'docker ps -af id={} --format "Image: {{ .Image }}\nCommand: {{ .Command }}\nCreated: {{ .CreatedAt }}\nStatus: {{ .Status }}"'
        )
    ) || return
    docker container kill -- "${containers[@]}"
}

__K_docker_rm() {
    local containers
    containers=(
        $(
            set -o pipefail
            docker ps -aq |
                fzf --multi --preview 'docker ps -af id={} --format "Image: {{ .Image }}\nCommand: {{ .Command }}\nCreated: {{ .CreatedAt }}\nStatus: {{ .Status }}"'
        )
    ) || return
    docker container rm -- "${containers[@]}"
}

__K_docker_rmi() {
    local images
    images=(
        $(
            set -o pipefail
            docker image ls --format '{{ if eq .Tag "<none>" }}{{ .ID }}{{ else }}{{ .Repository }}:{{ .Tag }}{{ end }}' |
                fzf --multi --preview 'docker image inspect --format "ID: {{ .ID }}'$'\n''Created: {{ .Created }}" {}'
        )
    ) || return
    docker image rm -- "${images[@]}"
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
        } | sort -u | fzf) || return
    git switch -- "${ref}"
}

__K_repo() {
    local dir=$(
        ls ~/source |
            fzf --preview 'shopt -s nullglob; cat "${HOME}"/source/{}/README*' |
            sed "s@^@${HOME}/source/@") || return
    cd -- "${dir}"
}

export FZF_DEFAULT_OPTS='--height 40% --cycle --bind=ctrl-z:ignore --marker="*" --color=dark,info:bright-cyan,prompt:cyan:bold,pointer:white,marker:white:bold'

__K_history() {
    local completion="$(builtin fc -lnr -10000000 | sed 's/^\t //' | fzf)"
    if [ -n "${completion}" ]; then
        READLINE_LINE="${completion}"
        READLINE_POINT=0x7fffffff
    fi
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
__K_git_switch     git    | Switch Branch {<.git}
__K_repo           misc   | Change Directory to a Repository
__K_kube_ctx       k8s    | Switch kubectl context
__K_gh_browse      misc   | Open Current Directory in Web Browser
EOF
       ) || return

    "${cmd}"
}
# We can't use `bind -x` because it forks.
bind '"\C-@": "\C-e\C-u Menu\n"'

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
    local dir
    dir=$(
        set -o pipefail
        { 
            find ~/source -maxdepth 3 -mindepth 3 -not -path '*/_/*' -printf '%P\n' | \
                awk -F/ '{print $2"/"$3" @ "$1}'
            if [ -d "${HOME}/source/_" ]; then
                ls "${HOME}/source/_"
            fi
        } | \
            fzf | \
            awk -F ' @ ' '{if(NF==2){print $2"/"$1}else{print "_/"$1}}'
    ) || return
    cd -- "${HOME}/source/${dir}"
}

__K_kube_ctx() {
    local context namespace
    context=$(kubectl config get-contexts --output=name | fzf) || return
    namespace=$(kubectl get namespace --context="${context}" --output=name | sed 's@namespace/@@; s/default/(\0)/' | fzf) || return
    namespace=$(sed 's/(default)//' <<<"${namespace}")
    kubectl config set-context "${context}" --namespace="${namespace}"
    kubectl config use-context "${context}"
}

__K_gh_browse() {
    gh browse
}

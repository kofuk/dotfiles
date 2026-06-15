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
__K_gh_browse      misc   | Open Current Directory in Web Browser {<.git}
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

__K_workspace_folders() {
    # Print "<display name>\t<folder path>" for each entry in the *.code-workspace
    # file given as $1. These files are JSONC (comments / trailing commas allowed),
    # so comments are stripped and trailing commas dropped before parsing with the
    # core JSON::PP module. perl is assumed present (it is also used by Menu and Git).
    perl -e '
        use strict; use warnings; use JSON::PP;
        binmode(STDOUT, q{:utf8});
        my $src = do { local $/; <> };
        defined $src or exit 0;
        # Keep string literals verbatim; drop // and /* */ comments.
        $src =~ s{("(?:\\.|[^"\\])*")|//[^\n]*|/\*.*?\*/}{defined $1 ? $1 : q{}}gesx;
        $src =~ s/,(\s*[}\]])/$1/g;  # drop trailing commas
        my $data = eval { decode_json($src) };
        exit 0 unless ref $data eq q{HASH} && ref $data->{folders} eq q{ARRAY};
        for my $f (@{$data->{folders}}) {
            next unless ref $f eq q{HASH} && defined $f->{path} && length $f->{path};
            my $name = (defined $f->{name} && length $f->{name}) ? $f->{name} : $f->{path};
            print $name, qq{\t}, $f->{path}, qq{\n};
        }
    ' -- "$1" 2>/dev/null
}

__K_repo() {
    # Each line fed to fzf is "<display>\t<target dir>"; only the display column
    # is shown and the target directory is recovered after selection.
    local dir
    dir=$(
        set -o pipefail
        {
            # Repository roots that hold a *.code-workspace; these are represented by
            # their workspace folder entries (including the "." root) instead of a
            # bare directory entry, to avoid a duplicate pointing at the same root.
            ws_dirs=$(find ~/source -maxdepth 4 -mindepth 4 -not -path '*/_/*' -name '*.code-workspace' -printf '%h\n' 2>/dev/null | sort -u)

            # Repositories: ~/source/<host>/<org>/<repo>, skipping workspace-backed ones.
            find ~/source -maxdepth 3 -mindepth 3 -not -path '*/_/*' -printf '%P\n' | \
                awk -F/ -v home="${HOME}" -v wslist="${ws_dirs}" '
                    BEGIN { n = split(wslist, a, "\n"); for (i = 1; i <= n; i++) ws[a[i]] = 1 }
                    { full = home"/source/"$0; if (!(full in ws)) print $2"/"$3" @ "$1"\t"full }
                '

            # Misc directories: ~/source/_/<name>
            if [ -d "${HOME}/source/_" ]; then
                find "${HOME}/source/_" -maxdepth 1 -mindepth 1 -printf '%P\t%p\n'
            fi

            # Folders declared in *.code-workspace files at repository roots.
            find ~/source -maxdepth 4 -mindepth 4 -not -path '*/_/*' -name '*.code-workspace' -print0 2>/dev/null | \
                while IFS= read -r -d '' ws; do
                    wsdir=$(dirname -- "${ws}")
                    wsname=$(basename -- "${ws}" .code-workspace)
                    __K_workspace_folders "${ws}" | \
                        while IFS=$'\t' read -r fname fpath; do
                            # Resolve relative/absolute folder paths against the workspace dir.
                            target=$(cd -- "${wsdir}" 2>/dev/null && cd -- "${fpath}" 2>/dev/null && pwd) || continue
                            printf '%s: %s\t%s\n' "${wsname}" "${fname}" "${target}"
                        done
                done
        } | \
            fzf --delimiter=$'\t' --with-nth=1 | \
            cut -f2
    ) || return
    cd -- "${dir}"
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

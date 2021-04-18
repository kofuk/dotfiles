# MSYS2-specific configuration

if [ -d "${USERPROFILE}/.cargo/bin" ]; then
    PATH="${USERPROFILE}/.cargo/bin:${PATH}"
fi

function packdep() {
    if [ "${#}" -lt 1 ]; then
        echo 'Filename required.'
    fi

    mkdir packdep
    cp "$1" packdep/.

    ldd "$1" | awk '$2=="=>"{if (match($3, "/mingw64/")) {print $3}}' | \
        xargs -I@ cp @ packdep/.
}

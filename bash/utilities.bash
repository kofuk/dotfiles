
# Utilities
function gengif() {
    if [ "$#" -lt 1 ]; then
        echo 'usage: gengif SOURCE [DST]'
        return 1
    fi

    local out_name
    if [ "$#" -ge 2 ]; then
        out_name="$2"
    else
        out_name='out.gif'
    fi
    local user_id="$(id -ur)"
    local palettepath="/tmp/palette-$user_id-$RANDOM.png"
    ffmpeg -i "$1" -vf palettegen "$palettepath" && \
        ffmpeg -i "$1" -i "$palettepath" -filter_complex paletteuse "$out_name"
    rm -f "$palettepath"
}

function gitapplyw32() {
    if [ "$#" -ne 1 ]; then
        echo 'usage: gitapplyw32 FILE'
        echo
        echo 'Apply UTF-16, CRLF patch file to git repository.'
    fi
    uconv -f UTF-16 -t UTF-8 "$1" | tr -d '\r' | git apply -
}

# XXX No longer works (because of Wayland)
function screenrecord() {
    if [ "$XDG_SESSION_TYPE" != "x11" ]; then
        echo 'Must run in Xorg session.'
        return 1
    fi

    local dimen="$(xdpyinfo | grep dimensions | head -n 1 | awk '{print $2}')"
    if [ -z "$dimen" ]; then
        echo 'Cannot retrive screen dimension.'
        return 1
    fi

    if [ $# -eq 0 ]; then
        echo 'screenrecord: fatal: Must specify output filename.'
        return 1;
    elif [ $# -ge 1 ]; then
        if [ "$1" = '--help' ]; then
            echo 'Usage: screenrecord [--with-audio] OUTNAME'
            return 0
        elif [ "$1" = '--with-audio' ]; then
            if [ $# -ge 2 ]; then
                ffmpeg -video_size "$dimen" -framerate 25 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default "$2"
            else
                echo 'Must specify output filename.'
                return 1
            fi
        else
            ffmpeg -video_size "$dimen" -framerate 25 -f x11grab -i :0.0+0,0 "$1"
            return 1
        fi
    fi
}

function tex2pdf() {
    if [ ! $# -eq 1 ]; then
        echo 'Please specify a texname' >&2
        return 1
    fi
    local filename="$1"
    if [ ! -f "$filename" ]; then
        if [ -f "$filename.tex" ]; then
            filename="$filename.tex"
        else
            echo "tex2pdf: $filename: No such file or directory"
            exit 1
        fi
    fi

    local logname="/tmp/${filename%.tex}.log"
    touch "$logname"
    if ! realpath "$filename" | grep '^/tmp/' &>/dev/null; then
        ln -s "$logname" .
    fi

    # if there is a `uplatex' option:
    if head -n 1 "$filename" |
            grep -E '^\\documentclass\[([[:alnum:]]+ ?, ?)*uplatex( ?, ?[[:alnum:]]+)*\]' &>/dev/null; then
        uplatex "$1" && dvipdfmx "${filename%.tex}.dvi"
    else
        platex "$1" && dvipdfmx "${filename%.tex}.dvi"
    fi

    if [ -h "${filename%.tex}.log" ]; then
        rm -f "${filename%.tex}.log"
    fi
}

function texclean() {
    rm -f *.aux *.dvi *.log *.toc
}

function texwatch() {
    if [ "$#" -lt 1 ]; then
        echo 'texname required.' >&2
        return 1
    fi
    local filename="$1"
    if ! echo "$filename" | grep '\.tex$' &>/dev/null; then
        filename="$filename.tex"
    fi

    local have_notify_send=
    if command -v notify-send &>/dev/null; then
        have_notify_send=yes
    fi

    inotifywait -meclose_write -- "$filename" |
        while read; do
            tex2pdf "$filename" || \
                (
                    echo -e '\e[37;41m              TeX COMPILATION FAILED!              \e[0m'
                    if [ "$have_notify_send" = yes ] && [ ! -z "$DISPLAY" ]; then
                        notify-send --urgency=low --icon=dialog-error 'TeX Compilation Failed!' "Unable to compile $filename."
                    fi
                );
        done
}

# convert text file to utf-8
function tofu() {
    if [ "$#" -ne 1 ]; then
        echo 'usage: tofu FILE' >&2
        return 1
    fi
    local enc="$(uchardet "$1")"
    if [ "$enc" = 'unknown' ]; then
        echo 'Unable to determine original encoding'
        return 1
    fi
    uconv -f "$enc" "$1"
}

function hijack() {
    if [ "$#" -ne 1 ]; then
        echo 'usage: hijack PID' >&2
        return 1
    fi
    local tty="$(readlink /proc/self/fd/0)"

    echo "Info: Connect to $tty"

    local run_as_root=
    if command -v sudo &>/dev/null && [ "_$(whoami)" != '_root' ]; then
        run_as_root=sudo
    fi

    local pid="$1"

    # TODO: Is it useful if we can write back current terminal attributes
    #       to the terminal disconnected?

    # Do NOT delete the empty line in heredoc;
    # This is a trick to skip stack trace in gdb (if it longer than terminal).
    $run_as_root gdb -p "$pid" <<EOF

compile code                                                        \
unsigned char attrs[3][1024];                                       \
for (int fd = 0; fd < 3; ++fd) {                                    \
    tcgetattr(fd, (struct termios *)attrs[fd]);                     \
}                                                                   \
dup2(open("$tty", 0 /* O_RDONLY */), 0);                            \
dup2(open("$tty", 1 /* O_WRONLY */), 1);                            \
dup2(open("$tty", 1 /* O_WRONLY */), 2);                            \
for (int fd = 0; fd < 3; ++fd) {                                    \
    tcsetattr(fd, 0 /* TCSADRAIN */, (struct termios *)attrs[fd]);  \
}
EOF
    # If this is TUI app, let it redraw.
    kill -WINCH "$pid"
    # wait for the process to terminate
    tail -f /dev/null --pid "$pid"
}

# same as dmake (CMake alias above) but build project in memory.
function mdmake() {
    local fs_type="$(df -P . | tail -n +2 | cut -d' ' -f1)"
    if [ "x$fs_type" = 'xtmpfs' ]; then
        local run_as_root=
        if [ "x$(whoami)" != 'xroot' ]; then
            run_as_root='sudo'
        fi
        $run_as_root mount -t tmpfs tmpfs . || \
            { echo 'Fatal: failed to mount tmpfs.'; return 1; }
        # move to tmpfs.
        cd .
    fi
    dmake "$@"
}

function fujisan() {
    export LSAN_OPTIONS='report_objects=1'
}

function htmlfy() {
    if [ $# -lt 1 ]; then
        echo 'fatal: source file expected.'
        exit 1;
    fi

    cat <<EOF
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>$1</title>
  <link rel="stylesheet" href="/css/dracula.css">
  <link rel="stylesheet" href="/css/code_base.css">
  <meta name="viewport" contents="width=device-width">
</head>
<body>
EOF
    pygmentize -f html "$1"
    echo '</body>'
}

function satyclean() {
    rm -f *.satysfi-aux
}

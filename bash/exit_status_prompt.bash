__last_exit="$?"

if [ "$__last_exit" -eq 0 ]; then
    echo -en '\e[38;5;14m'
    __message='success'
else
    echo -en '\e[38;5;13m'
    __message="failure ($__last_exit)"
fi

# Although some exceptions exist, exit status greater than 128 indicates
# signaled termination of the process, and its signal is (status code) - 128.
if [ "$__last_exit" -gt 128 ]; then
    __signum="$((__last_exit-128))"
    # `kill -l SIGNUM` prints signal name, like INT or TERM.
    __signal="$(kill -l "$__signum" 2>/dev/null)"

    if [ -z "$__signal" ]; then
        __signal='unknown signal'
    else
        __signal="SIG$__signal"
    fi
    __message="failure ($__last_exit/$__signal)"
fi

echo -n "//=> $__message"
echo -e '\e[0m'

unset __last_exit __message

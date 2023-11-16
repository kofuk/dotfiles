# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='cd*:ls*:git {status,push}*'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Edit and verify history before executing it.
shopt -s histverify

# Interpret unknown commands as cd
shopt -s autocd

if [ "${BASH_VERSINFO}" != 4 ]; then
    # Return empty if no file matched to glob.
    # This breaks completion with some old Bash and bash-completion versions,
    # so I disable nullglob on Bash 4 series.
    shopt -s nullglob
fi

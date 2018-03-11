# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# add golang binary path if it exists
if [ -d "/usr/local/go/bin" ]; then
    PATH="/usr/local/go/bin:$PATH"
fi

# Add Android-related environment variables if default directory for Android SDK exists
if [ -d "$HOME/Android" ]; then
    export ANDROID_HOME=$HOME/Android/Sdk
    PATH="$HOME/Android/Sdk/platform-tools:$PATH"

    # remark as android emulator to use system built-in libraries(e.g. libc++.so)
    export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
fi

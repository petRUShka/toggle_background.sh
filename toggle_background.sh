#!/bin/bash
GVIMRC=~/.vim/gvimrc
X_THEME_NAME=Xsolorized

if [ -z "$1" ]
then
    current_background=$(sed -n 's/[^!]\+Xsolorized\.\(\w\+\)\"/\1/p' ~/.Xresources)
    if [ "${current_background}" == 'light' ]; then
        new_background="dark"
    else
        new_background="light"
    fi
elif [ "${1}" == 'light' ] || [ "${1}" == 'dark' ]
then
    new_background="$1"
else
    echo "Unsupported background. The argument must be 'dark' or 'light'"
    exit 0
fi

# Xresources
XRESOURCES_THEME="$HOME/.${X_THEME_NAME}.${new_background}"
if [ -f "$XRESOURCES_THEME" ]
then
    echo "Xresources: changing theme to ${XRESOURCES_THEME}..."
    sed -i "s/[^!]\+${X_THEME_NAME}\.\(\w\+\)\"/#include \".${X_THEME_NAME}.${new_background}\"/" ~/.Xresources
else
    echo "Xresources: no such file ${XRESOURCES_THEME}. Skipping..."
fi

# gvim\gnvim config
if [ -f "$GVIMRC" ]
then
    sed -i "s/set background=\(\w\+\)/set background=${new_background}/" "$GVIMRC"
else
    echo "Vim/nvim gui: no such file ${GVIMRC}. Skipping..."
fi

# open vim/gvim/nvim instances
if [ -x "$(command -v vim)" ] && [ "$(vim --version | grep +clientserver)" ]
then
    for servername in $(vim --serverlist)
    do
        echo "Vim: changing background of instance with servername \"${servername}\""
        vim --servername "$servername" --remote-send "<Esc>:se background=${new_background}<CR>" &
    done
fi

if [ -x "$(command -v nvr)" ]
then
    for servername in $(nvr --serverlist)
    do
        echo "Nvim: changing background of instance with servername \"${servername}\""
        nvr --nostart --servername "$servername" --remote-send "<Esc>:se background=${new_background}<CR>" &
    done
fi

if [ -x "$(command -v xrdb)" ]
then
    echo "Xresources: sourcing updated \"$HOME/.Xresources\"..."
    xrdb "$HOME/.Xresources"
else
    echo "Xresources: xrdb isn't installed. Skipping sourcing updated \"$HOME/.Xresources\"..."
fi

if [ -x "$(command -v urxvt)" ] && [ -x "$(command -v pgrep)" ] && [ "$(grep 'URxvt.perl-ext-common:.\+config-reload' $HOME/.Xresources)" ]
then
    echo "Urxvt: reloading colorschemes..."
    kill -s SIGHUP "$(pgrep urxvt)"
else
    echo "Urxvt: skipping reloading colorschemes. One of urxvt, pgrep or urxvt-config-reload isn't installed."
fi

# TODO vifm

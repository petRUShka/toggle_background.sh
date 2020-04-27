# Synopsis
Script helps you to automatically switch background between dark and light version of your colorscheme in vim/neovim, Xresources (xterm, urxvt etc). It is extendible.

Optionally it is possible to setup run of the script automatically when it is dark or light. Or do it manually for example turn it to light when you are on sun or to dark when you are in a dim room.

# Installation

0. Install [requirements](#Requirements), most all of them are optional depending of what you need.
1. Place script in the directory within `$PATH`. In my case it is `$HOME/bin`. Example

```bash
cd ~/bin
wget https://raw.githubusercontent.com/petRUShka/toggle_background.sh/master/toggle_background.sh
```
2. Make it executable: `chmod +x toggle_background.sh`

# Usage

Toggle between light\dark

```bash
toggle_background.sh
```

Force dark or light:

```bash
toggle_background.sh dark
toggle_background.sh light
```

# Configuration
You can configure it through variables inside script.

You can change `GVIMRC` to different place or you can use `ginit.vim` for nvim gui:
```
GVIMRC=~/.config/nvim/ginit.vim
```

If you use both vim and nvim it is a good idea to source gvimrc in nvim or vice versa.

By default Xresources colorschemes filenames are expected [solorized colorschemes for Xresources](https://github.com/solarized/xresources): `~/.Xsolorized.dark` and `~/.Xsolorized.light` but you can change basename, for example:

```
X_THEME_NAME=Xresources
```

after that change script expects `~/.Xresources.dark` and `~/.Xresources.light`.

# Requirements
- place dark and light colorschemes for Xresources in `$HOME`, by default `~/.Xsolorized.dark` and `~/.Xsolorized.light` are expected. Also it is necessary to include in `~/.Xresources`, for example:
```
#include ".Xsolorized.dark"
```
- unset [background](https://vimhelp.org/options.txt.html#%27background%27) option in vimrc/init.nvim to vim/nvim guess background (dark\light) by the colorscheme of terminal;
- set [background](https://vimhelp.org/options.txt.html#%27background%27) in `gvimrc` to `dark` or `light`;
- vim compiled with [+clientserver](http://vimdoc.sourceforge.net/htmldoc/remote.html): for vim/gvim to change background on the fly;
- [neovim-remote](https://github.com/mhinz/neovim-remote): for nvim and guis to to change background on the fly;
- [xrdb](https://linux.die.net/man/1/xrdb) (X server resource database utility): for reloading Xresources config: xterm, uxterm etc;
- [urxvt-config-reload](https://github.com/regnarg/urxvt-config-reload): for live reloading color scheme of urxvt.
- [pgrep](https://gitlab.com/procps-ng/procps): for live update colorscheme of urxvt

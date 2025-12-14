# nvim

This is my own Neovim config.

Inspired by [LazyVim](https://www.lazyvim.org) but stripped down to only the things I need.

## To install

```console
git clone https://github.com/jcoopnz/nvim.git ~/.config/nvim && nvim
```

## To uninstall

```console
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

## Ghostty config

```console
auto-update = check
shell-integration = detect
shell-integration-features = title,ssh-env,ssh-terminfo,no-cursor
scrollback-limit = 10485760

font-size = 18
theme = tokyonight night
window-subtitle = working-directory
window-padding-x = 8
unfocused-split-opacity = 0.3

cursor-style = block
cursor-click-to-move = true
mouse-hide-while-typing = true

keybind = super+up=goto_split:up
keybind = super+down=goto_split:down
keybind = super+left=goto_split:left
keybind = super+right=goto_split:right

keybind = super+shift+up=resize_split:up,50
keybind = super+shift+down=resize_split:down,50
keybind = super+shift+left=resize_split:left,50
keybind = super+shift+right=resize_split:right,50
keybind = super+shift+enter=equalize_splits
keybind = super+shift+space=toggle_split_zoom
```

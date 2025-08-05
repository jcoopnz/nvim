# nvim

This is my own Neovim config.

Inspired by [LazyVim](https://www.lazyvim.org) but stripped down to only the things I need.

## To install

```console
git clone https://github.com/Jordy1311/nvim.git ~/.config/nvim && nvim
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
cursor-style = block
font-size = 16
scrollback-limit = 10485760
shell-integration = detect
shell-integration-features = title,no-cursor
theme = catppuccin-mocha
unfocused-split-opacity = 0.4
window-subtitle = working-directory

keybind = super+up=goto_split:up
keybind = super+down=goto_split:down
keybind = super+left=goto_split:left
keybind = super+right=goto_split:right

keybind = super+shift+up=resize_split:up,50
keybind = super+shift+down=resize_split:down,50
keybind = super+shift+left=resize_split:left,50
keybind = super+shift+right=resize_split:right,50
keybind = super+shift+enter=equalize_splits
```

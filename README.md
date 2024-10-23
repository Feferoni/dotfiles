# Setup linux env with useful programs and dotfiles

# Useful commands
### Batch renaming of files
```
ls | grep \.png$ | sed 'p;s/\.png/\.jpg/' | xargs -n2 mv
```
### Search and replace in certain files
Example with fd:
```
fd -e cpp -0 | xargs -0 sed -i 's/oldtext/newtext/g'
```
Example with find:
```
find . -type f -name "*.cpp" -print0 | xargs -0 sed -i 's/oldtext/newtext/g'
```

## Links
[Neovim](https://github.com/neovim/neovim)

[Neovim packet manager](https://github.com/wbthomason/packer.nvim)

[oh-my-zsh, follow their instructions on how to install](https://github.com/ohmyzsh/ohmyzsh/)

[base 16 terminal colors](https://github.com/tinted-theming/base16-shell)

[base 16 tmux](https://github.com/tinted-theming/base16-tmux)

[base 16 tmux powerline](https://github.com/teddyhwang/base16-tmux-powerline)

[base 16 vim](https://github.com/tinted-theming/base16-vim)

[Gogh, follow their instructions on how to install and switch color profiles](https://github.com/Gogh-Co/Gogh)

[Cattpucin theme, follow instructions in link to get the theme](https://github.com/catppuccin/windows-terminal)

[PowerToys - Useful tool to override keys in windows](https://github.com/microsoft/PowerToys)

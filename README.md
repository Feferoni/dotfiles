# Config dotfiles and environment setup
If any of the prerequisites doesn't work, see if you got a old version and replace that with the latest and greatest.

Language prerequisites:
* go

Common prerequisites:
* git
* [fzf](https://github.com/junegunn/fzf)
* ripgrep
* nodejs

## Tmux
Prerequisites:
* tmux
* xclip (used to copy to clipboard)
* A font that supports the symbols used in tmux powerline ([nerd fonts](https://github.com/ryanoasis/nerd-fonts) works)
* [tpm - tmux packet manger](https://github.com/tmux-plugins/tpm)   

Download the tmux packet managers:
```
mkdir -p ~/.tmux/plugins && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Copy or symlink the tmux .dotfile from/to the repo root:
```
cp .tmux.conf ~/
```
```
ln -s $PWD/.tmux.conf ~/
```
Install tmux plugins:
```
tmux
<tmuxPrefix> + I
```

## Neovim
Prerequisites:
* [Neovim](https://github.com/neovim/neovim) 
* [Neovim packet manager](https://github.com/wbthomason/packer.nvim)
* yarn, nodejs (for markdown preview)
    * [Markdown preview repo, follow the packer install instructions here if you don't want to use yarn or nodejs](https://github.com/iamcco/markdown-preview.nvim)

Download the neovim packet managers:
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Copy or symlink the neovim from/to the git repo (run from this repos root folder):
```
mkdir -p ~/.config
cp -r nvim/ ~/.config/
```
```
mkdir -p ~/.config
ln -s $PWD/nvim/ ~/.config/
```
Make sure that go delve (go debugger) is installed:
```
go install github.com/go-delve/delve/cmd/dlv@latest
```

Install vim packet manager and sync packets:
```
nvim ~/.config/nvim/lua/olle/packer.lua
:so
:PackerSync
```

## Zsh
Prerequisites:
* zsh
* [oh-my-zsh, follow their instructions on how to install](https://github.com/ohmyzsh/ohmyzsh/)

Copy or symlink the tmux .dotfile from/to the repo root:
```
cp .zshrc ~/
```
```
ln -s $PWD/.zshrc ~/
```

## Base 16 color theme - used to get a unifed theme across (zsh, tmux, tmux powerline and neovim)
[base 16 terminal colors](https://github.com/tinted-theming/base16-shell)

[base 16 tmux](https://github.com/tinted-theming/base16-tmux)

[base 16 tmux powerline](https://github.com/teddyhwang/base16-tmux-powerline)

[base 16 vim](https://github.com/tinted-theming/base16-vim)


## Color for terminal emulator (ignore this, old news)
### Linux
[Gogh, follow their instructions on how to install and switch color profiles](https://github.com/Gogh-Co/Gogh)

### WSL
[Cattpucin theme, follow instructions in link to get the theme](https://github.com/catppuccin/windows-terminal)

[PowerToys - Useful tool to override keys in windows](https://github.com/microsoft/PowerToys)

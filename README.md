# Config dotfiles and environment setup
If any of the prerequisites doesn't work, see if you got a old version and replace that with the latest and greatest.

Common prerequisites:
* git
* [fzf](https://github.com/junegunn/fzf)
* ripgrep

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

## Color for terminal emulator
[Gogh, follow their instructions on how to install and switch color profiles](https://github.com/Gogh-Co/Gogh)


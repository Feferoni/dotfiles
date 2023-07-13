# Config
Prerequisites:
* tmux
  * A font that supports the symbols used in tmux powerline ([nerd fonts](https://github.com/ryanoasis/nerd-fonts) works)
  * [tpm - tmux packet manger](https://github.com/tmux-plugins/tpm)   
* neovim
  * [Neovim packet manager](https://github.com/wbthomason/packer.nvim)
* ripgrep
* git
* [fzf](https://github.com/junegunn/fzf)

Commands to put the files in the correct locations:
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir -p ~/.tmux/plugins && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config && cp -r nvim ~/.config/ && cp .tmux.conf ~/
``` 

Install tmux plugins:
```
tmux
<tmux prefix - ctrl + a with these .tmux.conf> + I
```

Install vim packet manager and sync packets:
```
vim ~/.config/nvim/lua/olle/packer.lua
:so
:PackerSync
```

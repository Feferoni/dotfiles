# Config
Prerequisites:
* tmux
* neovim
* ripgrep
* git
* [fzf](https://github.com/junegunn/fzf)
* A font that supports the symbols used in tmux powerline ([nerd fonts](https://github.com/ryanoasis/nerd-fonts) works)
* [tpm](https://github.com/tmux-plugins/tpm)

Commands to put the files in the correct locations:
```
mkdir -p ~/.tmux/plugins && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config && cp -r nvim ~/.config/ && cp .tmux.conf ~/
``` 

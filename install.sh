#!/bin/bash

colored_echo() {
    local color_code="31"
    local text="$1"

    # ANSI color codes
    # Reset: 0, Red: 31, Green: 32, Yellow: 33, Blue: 34, Magenta: 35, Cyan: 36
    echo -e "\e[${color_code}m${text}\e[0m"
}

dotfile_repo_location=$PWD

if [ ! -f "$HOME/.configRepoPath" ]; then
    cat <<< "$dotfile_repo_location" > "$HOME/.configRepoPath"
fi

is_wsl() {
    grep -ic Microsoft /proc/version
}

install_with_apt() {
    programs_to_install=(git curl gettext sed unzip make cmake pkg-config build-essential tmux luajit zsh xclip ripgrep fzf ninja-build clang-tidy ccache)

    colored_echo "Using apt-get to install packages..."
    sudo apt-get update
    for program in "${programs_to_install[@]}"; do
        sudo apt-get install -y "$program"
    done

    if ! command -v snap >/dev/null 2>&1; then
        sudo apt-get install -y snap
    fi

    if [ $(is_wsl) -eq 1 ]; then
        wsl_conf_file="/etc/wsl.conf"
        colored_echo "If you have problem with snap installation, check the $wsl_conf_file and make sure that the following rows are in it:"
        colored_echo "[boot]"
        colored_echo "systemd=true"
        colored_echo ""
        colored_echo "If you change this, a restart of wsl is needed by writing \"wsl --shutdown\". Then run the script again to install stuff via snap."
        colored_echo "If it still doesn't work, try updating wsl by \"wsl --update\" then shutdown and restart wsl again."
        colored_echo ""
        colored_echo "I have been able to get this to work on some computer, don't know how though."
    fi

    sudo snap install bash-language-server --classic
    sudo snap install pyright --classic
    sudo snap install gopls --classic
    pip install -u yapf jedi-language-server
    done
}

install_pre_requisites() {
	if command -v apt-get >/dev/null 2>&1; then
		install_with_apt
	else
		colored_echo "No known supported package manager found."
	fi
}

create_symlink_with_backup() {
	local src_file="$1"
    local dest_dir="$HOME"
    if [ -n "$2" ]; then
        dest_dir="$2"
    fi

    if [ -z "$src_file" ] || [ -z "$dest_dir" ]; then
        colored_echo "Usage: create_symlink_with_backup source_file destination_directory"
        return 1
    fi

    if [ ! -f "$src_file" ]; then
        colored_echo "Source file does not exist: $src_file"
        return 1
    fi

    local filename=$(basename "$src_file")
    local dest_file="${dest_dir%/}/$filename"

    if [ -f "$dest_file" ]; then
        colored_echo "File already exists at destination. Creating backup: ${dest_file}.backup"
        mv "$dest_file" "${dest_file}.backup"
    fi

    ln -s "$src_file" "$dest_file"
    colored_echo "Symbolic link created for $src_file at $dest_dir"
}

colored_echo "Do you want to install pre-requisites programs via packet manager? y to install:"
read -r install_pre
if [ "$install_pre" = "y" ]; then
	install_pre_requisites
fi


colored_echo "Do you want to install tmux? y to install:"
read -r tmux_install
if [ "$tmux_install" = "y" ]; then
	create_symlink_with_backup "$dotfile_repo_location/.tmux.conf"
    mkdir -p ~/.tmux/plugins
    if [ ! -d "~/.tmux/plugins/tpm" ]; then
        colored_echo "Downloading tmux plugin manager repository."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null
    fi

    mkdir -p $HOME/bin
    ln -s "$dotfile_repo_location/bin/tmux_switch_session.sh $HOME/bin/"

    colored_echo "Tmux is setup, when opening tmux the next time press \"tmux prefix + I\" to install tmux plugins"
fi

colored_echo "Do you want to install nvim? y to install:"
read -r nvim_install
if [ "$nvim_install" = "y" ]; then
	create_symlink_with_backup "$dotfile_repo_location/.tmux.conf"
	mkdir -p ~/.config
	ln -s $dotfile_repo_location/nvim/ ~/.config/
    if ! command -v nvim >/dev/null 2>&1; then
        colored_echo "You don't have nvim installed, do you want to install it from source? Answer y to install."
        read -r install_nvim
        if [ "$install_nvim" = "y" ]; then
            colored_echo "Write the FULL path to where you want to download the neovim repository: "
            read -r neovim_path
            if [ -e "$neovim_path" ]; then
                cd $neovim_path
                git clone https://github.com/neovim/neovim
                cd neovim
                git checkout stable
                make CMAKE_BUILD_TYPE=Release
                sudo make install
                cd $dotfile_repo_location
            else
                colored_echo "Given path: $neovim_path is not a valid path. Rerun script and give a valid path."
            fi
        else
            colored_echo "You have to install nvim before continuing the script. Do it and rerun the script."
            exit 1
        fi
    fi

    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

    colored_echo "Neovim is setup. Open nvim with the command: \"nvim -u NONE ~/.config/nvim/lua/olle/packer.lua\" then run the following commands to install nvim plugins."
    colored_echo ":so"
    colored_echo ":PackerSync"
fi


colored_echo "Do you want to use zsh? y to install:"
read -r zsh_install
if [ "$zsh_install" = "y" ]; then
  	cd
	wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	chmod +x install.sh
	./install.sh
	rm -rf install.sh
	cd $dotfile_repo_location
	create_symlink_with_backup "$dotfile_repo_location/.zshrc"
fi

colored_echo "Do you want to install misc stuff? y for install:"
read -r misc_install
if [ "$misc_install" = "y" ]; then
    colored_echo "Downloading base16 shell colors"
    git clone https://github.com/tinted-theming/base16-shell.git $HOME/.config/base16-shell
    create_symlink_with_backup "$dotfile_repo_location/.gitconfig"

    mkdir -p $HOME/.config/yapf/
    create_symlink_with_backup "$dotfile_repo_location/style" "$HOME/.config/yapf"
fi

colored_echo "Do you want to install cargo? This will also download fd-find and bat. y for install:"
read -r cargo_install
if [ "$cargo_install" = "y" ]; then
    curl https://sh.rustup.rs -sSf | sh
    source "$HOME/.cargo/env"
    cargo install fd-find
    cargo install tree-sitter-cli
    cargo install bat
fi

colored_echo "If you want to install latest clang: visit https://apt.llvm.org/ and follow their instructions"
colored_echo "Setup should be complete, restart the terminal for full effect."

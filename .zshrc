######################################################################################
### Update config repo, needs to be first
######################################################################################
function check_and_pull_repo() {
    if [ "$SOURCED_RC" = true ]; then
        return 0
    fi

    if [ ! -f "$HOME/.configRepoPath" ]; then
        echo "Setup the file $HOME/.configRepoPath with the path to the config repo."
        return 0
    fi

    local repo_path=$(cat "$HOME/.configRepoPath")
    if [[ -d "${repo_path}/.git" ]]; then
        echo "Checking for updates in the repository: $repo_path"

        local before_pull_hash=$(git -C "$repo_path" rev-parse HEAD)
        git -C "$repo_path" pull
        local after_pull_hash=$(git -C "$repo_path" rev-parse HEAD)

        if [ "$before_pull_hash" != "$after_pull_hash" ]; then
            echo "Repository updated. Re-sourcing .zshrc."
            source "$HOME/.zshrc"
        fi
    else
        echo "Directory $repo_path is not a Git repository."
    fi
}
check_and_pull_repo

######################################################################################
### Functions
######################################################################################
is_wsl() {
    grep -qic Microsoft /proc/version
}


######################################################################################
### Exports
######################################################################################
export PATH=$HOME/programs/node-v20.0.0-linux-x64/bin:$PATH
export PATH=$HOME/programs/node-v20.0.0-linux-x64/lib/node_modules:$PATH
export PATH=$HOME/git/elixir/bin:$PATH
export PATH=$HOME/git/otp/bin:$PATH
export PATH=$HOME/.local/share/nvim/mason/bin/:$PATH
export PATH=$HOME/.local/bin/:$PATH
export PATH=/usr/local/lib/node_modules/:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=/snap/bin/:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/bin:$PATH
export CC=$(which clang)
export CXX=$(which clang++)
export ZSH="$HOME/.oh-my-zsh"
export BROWSER_PATH="firefox"

######################################################################################
### Aliases
######################################################################################
if command -v nvim &> /dev/null; then
  alias vim='nvim'
fi

alias sb='source ~/.zshrc'

######################################################################################
### Themes
######################################################################################
BASE16_SHELL_PATH="$HOME/.config/base16-shell"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL_PATH/profile_helper.sh" ] && \
    source "$BASE16_SHELL_PATH/profile_helper.sh"

ZSH_THEME="gentoo"

plugins=(
    git
    history-substring-search
    tmuxinator
)

source $ZSH/oh-my-zsh.sh

######################################################################################
### Rebinds
######################################################################################
bindkey '^O' clear-screen

######################################################################################
### Options
######################################################################################
setopt noincappendhistory
setopt nosharehistory

######################################################################################
### Wsl specific stuff
######################################################################################
if [ -z "${SOURCED_RC}" ] && is_wsl; then
    export PATH=$(echo "$PATH" | sed -e 's/:\/mnt[^:]*//g')
    export PATH=/mnt/c/Windows/System32:$PATH
    export BROWSER_PATH="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
    cd
fi

export SOURCED_RC=true

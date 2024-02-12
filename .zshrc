######################################################################################
### Functions
######################################################################################
function get_dotfile_json_entry() {
    local dotfile_path="$HOME/.dotfile_config.json"
    if [ ! -f "$dotfile_path" ]; then
        echo ""
        return 0
    fi
    if ! command -v jq >/dev/null 2>&1; then
        echo ""
        return 0
    fi

    local jq_args=()
    if [ -n "$2" ]; then
        jq_args+=($2)
    fi

    local query=$1
    local jq_response=$(jq "${jq_args[@]}" "$query" "$dotfile_path" | tr -d '"')
    local jq_response=${jq_response//\$HOME/$HOME} # expanding HOME var
    echo "$jq_response"
}
function check_and_pull_repo() {
    if [ "$SOURCED_RC" = true ]; then
        return 0
    fi

    local dotfile_path=$(get_dotfile_json_entry '.dotfile_path')

    if [ -z "$dotfile_path" ] || [ ! -d "$dotfile_path" ] || [ ! -d "$dotfile_path/.git" ]; then
        echo "Invalid or nonexistent dotfile path: $dotfile_path"
        return 0
    fi

    echo "Checking for updates in the repository: $repo_path"
    local before_pull_hash=$(git -C "$dotfile_path" rev-parse HEAD)
    git -C "$dotfile_path" pull
    local after_pull_hash=$(git -C "$dotfile_path" rev-parse HEAD)

    if [ "$before_pull_hash" != "$after_pull_hash" ]; then
        echo "Repository updated. Re-sourcing .zshrc."
        source "$HOME/.zshrc"
    fi

    export DOTFILE_PATH=$dotfile_path
}
check_and_pull_repo

declare -a PWD_HISTORY
PWD_HISTORY_SIZE=50

update_pwd_history() {
    if [ "$PWD" != "${PWD_HISTORY[1]}" ]; then
        PWD_HISTORY=("$PWD" "${PWD_HISTORY[@]}")
        PWD_HISTORY=("${PWD_HISTORY[@]:0:$PWD_HISTORY_SIZE}")
    fi
}

choose_from_pwd_history() {
    local dir_selected=$(printf "%s\n" "${PWD_HISTORY[@]}" | tail -n +2 | fzf --height 100% --inline-info --no-sort --tiebreak=index --header "Your PWD history (current PWD: ${PWD})")
    if [ -n "$dir_selected" ]; then
        cd "$dir_selected" && zle reset-prompt
    fi
}
zle -N pwd_hist choose_from_pwd_history

chpwd() { update_pwd_history; }

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
export GIT_FOLDER_PATH=$(get_dotfile_json_entry '.git_folder_path | join(":")' -r)

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
bindkey '^o' kill-line
bindkey '^b' clear-screen
bindkey '\C-p' pwd_hist

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

if [ -z "${SOURCED_RC}" ]; then
    export SOURCED_RC=true
    if tmux has-session -t default 2>/dev/null; then
        tmux attach -t default
    else
        tmux new -s default
    fi
fi


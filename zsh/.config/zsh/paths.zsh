# Personal Paths
export CODE="$HOME/Documents/Code"
export CPD="$HOME/Documents/Code/CPD"
export DOT="$HOME/.dotfiles/"
export WORK="$HOME/Documents/Code/Work"
export PERSONAL="$HOME/Documents/Code/Personal"
export LEARNING="$HOME/Documents/Code/Learning"
export SCRIPTS="$HOME/Documents/Scripts"
export ZEIT_DB="$XDG_CONFIG_HOME/zeit.db"
export NI_CONFIG_FILE="$XDG_CONFIG_HOME/nirc"
export PATH="$HOME/.opencode/bin:$PATH"

# Use XDG dirs for completion and history files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history

[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

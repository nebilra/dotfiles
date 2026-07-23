# zmodload zsh/zprof

ANTIDOTE_DIR=${ZDOTDIR:-~}/.antidote

# Install antidote if it doesn't exist
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    echo "Installing Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

source $ZDOTDIR/.antidote/antidote.zsh

HISTSIZE=10000
SAVEHIST=10000

antidote load

setopt correct

source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--style full --height 50% --layout reverse'

eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

precmd() { precmd() { echo "" } }

bindkey '^R' fzf-history-widget
bindkey '^P' up-line-or-beginning-search

# Custom zsh scripts
source $ZDOTDIR/paths.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/func.zsh

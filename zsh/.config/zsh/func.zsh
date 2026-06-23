# Personal Functions
function yz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function mkd() {
  command mkdir -p $1 && cd $1
}

function batf() {
  local filename="$1"
  if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' does not exist."
    return 1
  fi
  local extension="${filename##*.}"
  tail -f "$filename" | bat -l "$extension" --paging=never
}

function spotsync() {
  local query="$1"
  local audio_src="$2"
  if [[ -z $query ]]; then
    spotdl sync .spotdl --lyrics genius musixmatch
    return 1
  fi
  if [[ -z $audio_src ]]; then
    spotdl sync "$query" --save-file .spotdl --lyrics genius musixmatch
    return 0
  fi
  spotdl sync "$query" --save-file .spotdl --audio "$audio_src" --lyrics genius musixmatch
}

function help() {
  local command_name="$1"

  if [[ -z "$command_name" ]]; then
    echo "Usage: help <command>"
    return 1
  fi

  # Try --help first, as it's often more concise for quick help
  if "$command_name" --help 2>&1 | less; then
    return 0
  fi

  # If --help fails, try man pages
  if man "$command_name" | less; then
    return 0
  fi

  echo "Could not find help documentation for '$command_name'."
  return 1
}

function zs() {
  zesh cn "$(zesh l | fzf)"
}

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' TMUX ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}


function sesh-list() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list | fzf --height 40% --reverse --border-label ' TMUX ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

function zesh-list() {
  {
    exec </dev/tty
    exec <&1
    zesh
    zle reset-prompt > /dev/null 2>&1 || true
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

zle     -N             sesh-list
bindkey -M emacs '\ea' sesh-list
bindkey -M vicmd '\ea' sesh-list
bindkey -M viins '\ea' sesh-list

zle     -N             zesh-list
bindkey -M emacs '\ef' zesh-list
bindkey -M vicmd '\ef' zesh-list
bindkey -M viins '\ef' zesh-list

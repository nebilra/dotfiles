# Clean up
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_DIR="$HOME/.local/bin"

export ANDROID_HOME="$XDG_DATA_HOME/android/sdk"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle 
export LEIN_HOME="$XDG_DATA_HOME"/lein 
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc 
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc":"$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"

path+=( 
	$ANDROID_HOME/platform-tools
	$ANDROID_HOME/cmdline-tools/latest/bin
	$ANDROID_HOME/build-tools/34.0.0
	$GOPATH/bin
	$XDG_DATA_HOME/spicetify
	$HOME/Documents/Scripts
	$XDG_BIN_DIR
	# $XDG_BIN_DIR/opencode/bin
	$XDG_DATA_HOME/bin
	$XDG_DATA_HOME/bin/my-scripts
	$XDG_DATA_HOME/pnpm
	$CARGO_HOME/bin
)
export path

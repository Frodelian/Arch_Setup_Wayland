if [[ -z "$XDG_CONFIG_HOME" ]] 
then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/screenshots"

if [[ -d "$XDG_CONFIG_HOME/zsh" ]] 
then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

export LC_ALL=en_US.UTF-8


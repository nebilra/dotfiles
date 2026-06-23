#!/bin/bash
#
# mediactl - Unified media control for Hyprland
# Handles mpd + spotify + general MPRIS players

action="$1"

# Function to detect if anything is playing
is_playing() {
    playerctl status -a 2>/dev/null | grep -q "Playing"
}

case "$action" in
    playpause)
        if is_playing; then
            # Pause whatever is playing
            playerctl pause -a
        else
            # Nothing is playing → prefer mpd if running, else spotify
            if pgrep -x spotify >/dev/null; then
                playerctl --player=spotify play-pause
            elif pgrep -x mpd >/dev/null; then
                playerctl --player=mpd play-pause
            else
                # fallback: generic
                playerctl play-pause
            fi
        fi
        ;;
    next)
        if pgrep -x spotify >/dev/null; then
            playerctl --player=spotify next
        elif pgrep -x mpd >/dev/null; then
            playerctl --player=mpd next
        else
            playerctl next
        fi
        ;;
    prev|previous)
        if pgrep -x spotify >/dev/null; then
            playerctl --player=spotify previous
        elif pgrep -x mpd >/dev/null; then
            playerctl --player=mpd previous
        else
            playerctl previous
        fi
        ;;
    *)
        echo "Usage: $0 {playpause|next|prev}" >&2
        exit 1
        ;;
esac

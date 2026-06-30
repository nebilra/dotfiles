#!/usr/bin/env bash

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/activitywatch"
SCRIPT_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/activitywatch"
mkdir -p "$LOG_DIR"

AW_SERVER_LOG="$LOG_DIR/aw-server.log"
AWATCHER_LOG="$LOG_DIR/awatcher.log"

# ---- prevent duplicate runs ----
if pgrep -x "aw-server-rust" > /dev/null; then
    echo "aw-server-rust already running"
else
    nohup "$SCRIPT_DIR/aw-server-rust/aw-server-rust" >> "$AW_SERVER_LOG" 2>&1 &
    echo "started aw-server-rust"
fi

sleep 2

if pgrep -x "awatcher" > /dev/null; then
    echo "awatcher already running"
else
    nohup awatcher >> "$AWATCHER_LOG" 2>&1 &
    echo "started awatcher"
fi

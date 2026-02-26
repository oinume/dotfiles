#!/bin/bash

# set -eux

# macOS notification tool for Claude Code
# Need to install terminal-notifier with homebrew and link like below
# ln -s /opt/homebrew/Cellar/terminal-notifier/2.0.0/terminal-notifier.app /Applications/terminal-notifier.app

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
project=$(basename "$cwd")
notification_type=$(echo "$input" | jq -r '.notification_type')

send_notification() {
  local message="$1"
  local sound="$2"

  local args=(-title "Claude Code" -subtitle "${project}" -message "${message}")
  if [[ -n "${sound}" ]]; then
    args+=(-sound "${sound}")
  fi
  terminal-notifier "${args[@]}"
}

case "${notification_type}" in
  "permission_prompt")
    send_notification "🔑 permission prompt" "Ping"
    ;;
  "idle_prompt"|"elicitation_dialog")
    send_notification "🙋 idle prompt" "Purr"
    ;;
  "stop")
    send_notification "✅ done" "Glass"
    ;;
  *)
    send_notification "🔔 notification" ""
    ;;
esac

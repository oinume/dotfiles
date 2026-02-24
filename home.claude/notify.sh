#!/bin/bash

# You need to allow osascript to notify, see below.
# https://qiita.com/tanaka4410/items/e6cfef46169273ed3efe

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
project=$(basename "$cwd")
notification_type=$(echo "$input" | jq -r '.notification_type')

send_notification() {
  local message="$1"
  local sound="$2"

  local args="display notification \"${message}\" with title \"Claude Code\" subtitle \"${project}\""
  if [[ -n "${sound}" ]]; then
    args="${args} sound name \"${sound}\""
  fi
  osascript -e "${args}"
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

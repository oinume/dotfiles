#!/bin/bash

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
    send_notification "許可待ち" "Ping"
    ;;
  "idle_prompt"|"elicitation_dialog")
    send_notification "入力待ち" "Purr"
    ;;
  "stop")
    send_notification "タスク完了" "Glass"
    ;;
  *)
    send_notification "通知" ""
    ;;
esac

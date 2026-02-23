#!/bin/bash

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
project=$(basename "$cwd")
notification_type=$(echo "$input" | jq -r '.notification_type')

# ターミナルアプリの Bundle ID を自動検出
get_terminal_bundle_id() {
  # __CFBundleIdentifier が設定されていれば直接使用（最も確実）
  if [[ -n "${__CFBundleIdentifier}" ]]; then
    echo "${__CFBundleIdentifier}"
    return
  fi

  # TERM_PROGRAM 環境変数から検出（フォールバック）
  case "${TERM_PROGRAM}" in
    "Apple_Terminal") echo "com.apple.Terminal" ;;
    "iTerm.app")      echo "com.googlecode.iterm2" ;;
    "ghostty")        echo "com.mitchellh.ghostty" ;;
    "WarpTerminal")   echo "dev.warp.Warp-Stable" ;;
    *)
      # プロセスツリーから検出
      local pid parent comm
      pid=$$
      while [[ "${pid}" -ne 1 ]] 2>/dev/null; do
        parent=$(ps -p "${pid}" -o ppid= 2>/dev/null | tr -d ' ') || break
        [[ -z "${parent}" ]] && break
        comm=$(ps -p "${parent}" -o comm= 2>/dev/null)
        case "${comm}" in
          *Terminal*)  echo "com.apple.Terminal"; return ;;
          *iTerm*)     echo "com.googlecode.iterm2"; return ;;
          *Cursor*)    echo "com.todesktop.230313mzl4w4u92"; return ;;
          *Code*)      echo "com.microsoft.VSCode"; return ;;
          *ghostty*)   echo "com.mitchellh.ghostty"; return ;;
          *warp*)      echo "dev.warp.Warp-Stable"; return ;;
          *)           ;;
        esac
        pid="${parent}"
      done
      echo ""
      ;;
  esac
}

BUNDLE_ID=$(get_terminal_bundle_id)

send_notification() {
  local message="$1"
  local sound="$2"

  if [[ -n "${BUNDLE_ID}" ]]; then
    terminal-notifier -title "Claude Code" -subtitle "${project}" -message "${message}" -sound "${sound}" -activate "${BUNDLE_ID}"
  else
    terminal-notifier -title "Claude Code" -subtitle "${project}" -message "${message}" -sound "${sound}"
  fi
}

case "${notification_type}" in
  "permission_prompt")
    send_notification "許可待ち" "Ping"
    ;;
  "idle_prompt")
    send_notification "入力待ち" "Purr"
    ;;
  "stop")
    send_notification "タスク完了" "Glass"
    ;;
  *)
    send_notification "通知" ""
    ;;
esac

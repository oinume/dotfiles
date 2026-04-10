#!/bin/bash
# List all available accounts (useful for debugging)

osascript <<'EOF'
tell application "Notes"
    try
        set accountList to every account
        set accountNames to {}
        repeat with acc in accountList
            set end of accountNames to name of acc
        end repeat
        set AppleScript's text item delimiters to "\n"
        return accountNames as string
    on error errMsg
        return "Error: " & errMsg
    end try
end tell
EOF

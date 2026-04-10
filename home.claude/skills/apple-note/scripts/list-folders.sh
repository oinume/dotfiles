#!/bin/bash
# List all folders in Apple Notes

ACCOUNT="${1:-iCloud}"

osascript - "$ACCOUNT" <<'EOF'
on run argv
    set accName to item 1 of argv
    tell application "Notes"
        try
            set folderList to every folder in account accName
            set folderNames to {}
            repeat with fldr in folderList
                set end of folderNames to name of fldr
            end repeat
            set AppleScript's text item delimiters to "\n"
            return folderNames as string
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

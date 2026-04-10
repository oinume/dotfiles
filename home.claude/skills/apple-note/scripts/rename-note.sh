#!/bin/bash
# Rename a note

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
OLD_NAME="$3"
NEW_NAME="$4"

if [ -z "$OLD_NAME" ] || [ -z "$NEW_NAME" ]; then
    echo "Error: Both old and new names are required"
    echo "Usage: $0 [account] [folder] <old_name> <new_name>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$OLD_NAME" "$NEW_NAME" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set oldName to item 3 of argv
    set newName to item 4 of argv

    tell application "Notes"
        try
            set theNote to note oldName in folder folName of account accName
            set name of theNote to newName
            return "Success: Renamed note from '" & oldName & "' to '" & newName & "'"
        on error errMsg number errNum
            if errNum is -1728 then
                return "Error: Note '" & oldName & "' not found in folder '" & folName & "'"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
EOF

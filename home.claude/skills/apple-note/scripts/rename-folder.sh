#!/bin/bash
# Rename a folder

ACCOUNT="${1:-iCloud}"
OLD_NAME="$2"
NEW_NAME="$3"

if [ -z "$OLD_NAME" ] || [ -z "$NEW_NAME" ]; then
    echo "Error: Both old and new folder names are required"
    echo "Usage: $0 [account] <old_name> <new_name>"
    exit 1
fi

osascript - "$ACCOUNT" "$OLD_NAME" "$NEW_NAME" <<'EOF'
on run argv
    set accName to item 1 of argv
    set oldName to item 2 of argv
    set newName to item 3 of argv

    tell application "Notes"
        try
            tell account accName
                -- Check if new name already exists
                try
                    set existingFolder to folder newName
                    return "Error: A folder named '" & newName & "' already exists"
                on error
                    -- Continue with rename
                end try

                set theFolder to folder oldName
                set name of theFolder to newName
                return "Success: Renamed folder from '" & oldName & "' to '" & newName & "'"
            end tell
        on error errMsg number errNum
            if errNum is -1719 then
                return "Error: Folder '" & oldName & "' not found"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
EOF

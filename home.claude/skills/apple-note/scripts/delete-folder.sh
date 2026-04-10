#!/bin/bash
# Delete a folder (must be empty)
# WARNING: This action cannot be undone!

ACCOUNT="${1:-iCloud}"
FOLDER_NAME="$2"

if [ -z "$FOLDER_NAME" ]; then
    echo "Error: Folder name is required"
    echo "Usage: $0 [account] <folder_name>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER_NAME" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folderName to item 2 of argv

    tell application "Notes"
        try
            tell account accName
                set theFolder to folder folderName
                -- Check if folder has notes
                set noteCount to count of notes in theFolder
                if noteCount > 0 then
                    return "Error: Folder '" & folderName & "' contains " & noteCount & " note(s). Please move or delete notes first."
                end if
                delete theFolder
                return "Success: Deleted folder '" & folderName & "'"
            end tell
        on error errMsg number errNum
            if errNum is -1719 then
                return "Error: Folder '" & folderName & "' not found"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
EOF

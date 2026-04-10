#!/bin/bash
# Create a new folder in Apple Notes

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
                -- Check if folder already exists
                try
                    set existingFolder to folder folderName
                    return "Error: Folder '" & folderName & "' already exists"
                on error
                    -- Folder doesn't exist, create it
                    make new folder with properties {name:folderName}
                    return "Success: Created folder '" & folderName & "'"
                end try
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

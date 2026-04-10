#!/bin/bash
# Get the content of a specific note

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_NAME="$3"

if [ -z "$NOTE_NAME" ]; then
    echo "Error: Note name is required"
    echo "Usage: $0 [account] [folder] <note_name>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv
    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            return body of theNote
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

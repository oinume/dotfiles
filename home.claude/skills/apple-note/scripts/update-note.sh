#!/bin/bash
# Update an existing note in Apple Notes (full replacement)
# For appending, first read the note, then combine content before calling this script

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_NAME="$3"
NEW_CONTENT="$4"

if [ -z "$NOTE_NAME" ] || [ -z "$NEW_CONTENT" ]; then
    echo "Error: Note name and content are required"
    echo "Usage: $0 [account] [folder] <note_name> <new_content>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" "$NEW_CONTENT" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv
    set newBody to item 4 of argv

    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            -- Wrap content in div for proper HTML formatting
            set formattedBody to "<div>" & newBody & "</div>"
            set body of theNote to formattedBody
            return "Success: Updated note '" & noteName & "'"
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

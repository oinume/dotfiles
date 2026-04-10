#!/bin/bash
# Create a new note in Apple Notes
# Usage: ./create-note.sh [account] [folder] <note_title> [note_content]

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_TITLE="$3"
NOTE_CONTENT="${4:-}"

if [ -z "$NOTE_TITLE" ]; then
    echo "Error: Note title is required"
    echo "Usage: $0 [account] [folder] <note_title> [note_content]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_TITLE" "$NOTE_CONTENT" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteTitle to item 3 of argv
    set noteBody to item 4 of argv

    tell application "Notes"
        try
            tell account accName
                set theFolder to folder folName
                -- Wrap content in div for proper HTML formatting
                if noteBody is not "" then
                    set formattedBody to "<div>" & noteBody & "</div>"
                else
                    set formattedBody to ""
                end if
                set newNote to make new note at theFolder with properties {name:noteTitle, body:formattedBody}
                return "Success: Created note '" & noteTitle & "' (ID: " & id of newNote & ")"
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

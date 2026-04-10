#!/bin/bash
# Delete a note from Apple Notes
# WARNING: This action cannot be undone!

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
            set noteId to id of theNote
            delete theNote
            return "Success: Deleted note '" & noteName & "'"
        on error errMsg number errNum
            if errNum is -1719 then
                return "Error: Note '" & noteName & "' not found in folder '" & folName & "'"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
EOF

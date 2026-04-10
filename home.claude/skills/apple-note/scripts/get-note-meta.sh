#!/bin/bash
# Get metadata for a specific note
# Returns: ID, name, creation date, modification date, folder, account

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
            set noteNameVal to name of theNote
            set createdVal to creation date of theNote
            set modifiedVal to modification date of theNote
            set noteBody to body of theNote
            set bodyLength to length of noteBody

            set metaData to "ID: " & noteId & return
            set metaData to metaData & "Name: " & noteNameVal & return
            set metaData to metaData & "Folder: " & folName & return
            set metaData to metaData & "Account: " & accName & return
            set metaData to metaData & "Created: " & (createdVal as string) & return
            set metaData to metaData & "Modified: " & (modifiedVal as string) & return
            set metaData to metaData & "Body Length: " & bodyLength & " characters"

            return metaData
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

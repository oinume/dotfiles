#!/bin/bash
# Move a note to another folder

ACCOUNT="${1:-iCloud}"
SOURCE_FOLDER="${2:-Notes}"
NOTE_NAME="$3"
TARGET_FOLDER="$4"

if [ -z "$NOTE_NAME" ] || [ -z "$TARGET_FOLDER" ]; then
    echo "Error: Note name and target folder are required"
    echo "Usage: $0 [account] <source_folder> <note_name> <target_folder>"
    exit 1
fi

osascript - "$ACCOUNT" "$SOURCE_FOLDER" "$NOTE_NAME" "$TARGET_FOLDER" <<'EOF'
on run argv
    set accName to item 1 of argv
    set sourceFol to item 2 of argv
    set noteName to item 3 of argv
    set targetFol to item 4 of argv

    tell application "Notes"
        try
            -- Get the source note
            set theNote to note noteName in folder sourceFol of account accName

            -- Check if target folder exists
            try
                set targetFolder to folder targetFol of account accName
            on error
                return "Error: Target folder '" & targetFol & "' not found"
            end try

            -- Move the note
            move theNote to targetFolder
            return "Success: Moved note '" & noteName & "' to '" & targetFol & "'"

        on error errMsg number errNum
            if errNum is -1719 then
                return "Error: Note '" & noteName & "' not found in folder '" & sourceFol & "'"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
EOF

#!/bin/bash
# Copy a note to another folder (creates a duplicate)

ACCOUNT="${1:-iCloud}"
SOURCE_FOLDER="${2:-Notes}"
NOTE_NAME="$3"
TARGET_FOLDER="$4"
COPY_NAME="${5:-}"  # Optional: new name for the copy

if [ -z "$NOTE_NAME" ] || [ -z "$TARGET_FOLDER" ]; then
    echo "Error: Note name and target folder are required"
    echo "Usage: $0 [account] <source_folder> <note_name> <target_folder> [copy_name]"
    exit 1
fi

osascript - "$ACCOUNT" "$SOURCE_FOLDER" "$NOTE_NAME" "$TARGET_FOLDER" "$COPY_NAME" <<'EOF'
on run argv
    set accName to item 1 of argv
    set sourceFol to item 2 of argv
    set noteName to item 3 of argv
    set targetFol to item 4 of argv
    set copyName to item 5 of argv

    tell application "Notes"
        try
            -- Get the source note
            set theNote to note noteName in folder sourceFol of account accName
            set noteBody to body of theNote
            set noteCreationDate to creation date of theNote
            set noteModificationDate to modification date of theNote

            -- Check if target folder exists
            try
                set targetFolder to folder targetFol of account accName
            on error
                return "Error: Target folder '" & targetFol & "' not found"
            end try

            -- Determine the copy name
            if copyName is not "" then
                set newName to copyName
            else
                set newName to noteName & " (copy)"
            end if

            -- Create the copy
            set newNote to make new note at targetFolder with properties {name:newName, body:noteBody}
            return "Success: Copied note '" & noteName & "' to '" & targetFol & "' as '" & newName & "'"

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

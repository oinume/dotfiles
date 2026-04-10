#!/bin/bash
# Move multiple notes matching a keyword to another folder

ACCOUNT="${1:-iCloud}"
SOURCE_FOLDER="${2:-Notes}"
KEYWORD="$3"
TARGET_FOLDER="$4"

if [ -z "$KEYWORD" ] || [ -z "$TARGET_FOLDER" ]; then
    echo "Error: Keyword and target folder are required"
    echo "Usage: $0 [account] <source_folder> <keyword> <target_folder>"
    exit 1
fi

osascript - "$ACCOUNT" "$SOURCE_FOLDER" "$KEYWORD" "$TARGET_FOLDER" <<'EOF'
on run argv
    set accName to item 1 of argv
    set sourceFol to item 2 of argv
    set keyword to item 3 of argv
    set targetFol to item 4 of argv

    tell application "Notes"
        try
            -- Check if target folder exists
            try
                set targetFolder to folder targetFol of account accName
            on error
                return "Error: Target folder '" & targetFol & "' not found"
            end try

            tell folder sourceFol of account accName
                -- Find all matching notes
                set matchingNotes to every note whose name contains keyword
                set noteCount to count of matchingNotes

                if noteCount is 0 then
                    return "No notes found containing '" & keyword & "'"
                end if

                -- Move all matching notes
                set movedNames to {}
                repeat with nte in matchingNotes
                    set end of movedNames to name of nte
                    move nte to targetFolder
                end repeat

                set AppleScript's text item delimiters to ", "
                return "Success: Moved " & noteCount & " note(s) to '" & targetFol & "': " & (movedNames as string)
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

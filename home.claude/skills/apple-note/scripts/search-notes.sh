#!/bin/bash
# Search for notes by keyword in title or body
# Uses 'whose' clause for database-level filtering (much faster)

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
KEYWORD="$3"

if [ -z "$KEYWORD" ]; then
    echo "Error: Keyword is required"
    echo "Usage: $0 [account] [folder] <keyword>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$KEYWORD" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set keyword to item 3 of argv

    tell application "Notes"
        try
            tell folder folName of account accName
                -- Use whose clause for fast database-level filtering
                set matchingNotes to every note whose name contains keyword or body contains keyword
                set matchNames to {}
                repeat with nte in matchingNotes
                    set end of matchNames to name of nte
                end repeat
                set AppleScript's text item delimiters to "\n"
                return matchNames as string
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

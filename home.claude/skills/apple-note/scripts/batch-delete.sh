#!/bin/bash
# Delete multiple notes matching a keyword pattern
# WARNING: This action cannot be undone!

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
KEYWORD="$3"

if [ -z "$KEYWORD" ]; then
    echo "Error: Keyword is required"
    echo "Usage: $0 [account] [folder] <keyword>"
    echo "This will delete ALL notes containing the keyword in their name"
    echo ""
    echo "To preview which notes will be deleted, use:"
    echo "  ./search-notes.sh [account] [folder] <keyword>"
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
                -- Find all matching notes
                set matchingNotes to every note whose name contains keyword
                set noteCount to count of matchingNotes

                if noteCount is 0 then
                    return "No notes found containing '" & keyword & "'"
                end if

                -- Delete all matching notes
                set deletedNames to {}
                repeat with nte in matchingNotes
                    set end of deletedNames to name of nte
                    delete nte
                end repeat

                set AppleScript's text item delimiters to ", "
                return "Success: Deleted " & noteCount & " note(s): " & (deletedNames as string)
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

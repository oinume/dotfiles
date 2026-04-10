#!/bin/bash
# Create a note with link preview (Apple Notes rich link format)
# Usage: ./create-link-preview.sh [account] [folder] <note_title> <url>

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_TITLE="$3"
URL="$4"

if [ -z "$NOTE_TITLE" ] || [ -z "$URL" ]; then
    echo "Error: Note title and URL are required"
    echo "Usage: $0 [account] [folder] <note_title> <url>"
    exit 1
fi

# Apple Notes link preview format: <a href="URL">URL</a>
# Using proper HTML with quoted attributes
LINK_HTML="<a href=\"$URL\">$URL</a>"

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_TITLE" "$LINK_HTML" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteTitle to item 3 of argv
    set linkHtml to item 4 of argv

    tell application "Notes"
        try
            tell account accName
                set theFolder to folder folName
                set newNote to make new note at theFolder with properties {name:noteTitle, body:linkHtml}
                return "Success: Created note with link preview '" & noteTitle & "'"
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

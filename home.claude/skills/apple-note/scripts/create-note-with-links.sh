#!/bin/bash
# Create a note with multiple link previews
# Each line: URL or "Description|URL"

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_TITLE="$3"
shift 3
LINKS=("$@")

if [ -z "$NOTE_TITLE" ] || [ ${#LINKS[@]} -eq 0 ]; then
    echo "Error: Note title and at least one link are required"
    echo "Usage: $0 [account] [folder] <note_title> <url1> [url2] ..."
    echo "   or: $0 [account] [folder] <note_title> \"Description|URL\" ..."
    exit 1
fi

# Build HTML content
CONTENT="<div>$NOTE_TITLE</div><div><br></div>"

for link in "${LINKS[@]}"; do
    if [[ "$link" == *"|"* ]]; then
        # Format: "Description|URL"
        DESC="${link%%|*}"
        URL="${link##*|}"
        CONTENT="$CONTENT<div>$DESC</div>"
        CONTENT="$CONTENT<a href=\"$URL\">$URL</a><div><br></div>"
    else
        # Format: URL only
        CONTENT="$CONTENT<a href=\"$link\">$link</a><div><br></div>"
    fi
done

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_TITLE" "$CONTENT" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteTitle to item 3 of argv
    set noteBody to item 4 of argv

    tell application "Notes"
        try
            tell account accName
                set theFolder to folder folName
                set newNote to make new note at theFolder with properties {name:noteTitle, body:noteBody}
                return "Success: Created note '" & noteTitle & "' with ${#LINKS[@]} link(s)"
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

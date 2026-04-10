#!/bin/bash
# Add a file link to a note
# Note: Apple Notes does not support programmatic file attachments via AppleScript.
# This creates a file:// link in the note (clickable but requires manual open).

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_NAME="$3"
FILE_PATH="$4"

if [ -z "$NOTE_NAME" ] || [ -z "$FILE_PATH" ]; then
    echo "Error: Note name and file path are required"
    echo "Usage: $0 [account] [folder] <note_name> <file_path>"
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found: $FILE_PATH"
    exit 1
fi

# Get absolute path
if [[ "$FILE_PATH" != /* ]]; then
    FILE_PATH="$(pwd)/$FILE_PATH"
fi

FILE_NAME=$(basename "$FILE_PATH")
FILE_SIZE=$(ls -lh "$FILE_PATH" | awk '{print $5}')
FILE_EXT="${FILE_PATH##*.}"

# Determine icon based on file type
case "$FILE_EXT" in
    png|jpg|jpeg|gif|webp|heic) ICON="🖼️" ;;
    pdf) ICON="📄" ;;
    doc|docx|pages) ICON="📝" ;;
    xls|xlsx|numbers) ICON="📊" ;;
    ppt|pptx|keynote) ICON="📽️" ;;
    zip|tar|gz|rar|7z) ICON="📦" ;;
    txt|md|csv) ICON="📃" ;;
    *) ICON="📎" ;;
esac

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" "$FILE_PATH" "$FILE_NAME" "$FILE_SIZE" "$ICON" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv
    set filePath to item 4 of argv
    set fileName to item 5 of argv
    set fileSize to item 6 of argv
    set fileIcon to item 7 of argv

    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            set currentBody to body of theNote

            -- Create file:// link (clickable in Notes)
            set fileLink to "<div><a href=\"file://" & filePath & "\">" & fileIcon & " " & fileName & " (" & fileSize & ")</a></div><div><br></div>"

            set body of theNote to currentBody & fileLink
            return "Success: Added file link to note '" & noteName & "'"

        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF


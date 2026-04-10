#!/bin/bash
# Create a note with rich link using attachment method
# This attempts to use AppleScript's make new attachment to trigger preview
# Success rate varies by macOS version
#
# Usage: ./create-rich-link-attachment.sh [account] [folder] <note_title> <url>

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_TITLE="$3"
URL="$4"

if [ -z "$NOTE_TITLE" ] || [ -z "$URL" ]; then
    echo "Error: Note title and URL are required"
    echo "Usage: $0 [account] [folder] <note_title> <url>"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_TITLE" "$URL" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteTitle to item 3 of argv
    set webUrl to item 4 of argv

    tell application "Notes"
        try
            tell account accName
                tell folder folName
                    -- Create the note first
                    set theNote to make new note with properties {name:noteTitle}

                    -- Try to add URL as attachment (may trigger preview on some macOS versions)
                    -- This uses the attachment mechanism instead of HTML body
                    try
                        make new attachment at theNote with properties {url:webUrl}
                        return "Success: Created note with attachment (preview may appear on supported macOS versions)"
                    on error attachErr
                        -- Fallback: Add URL to body if attachment fails
                        set body of theNote to "<div><a href=" & webUrl & ">" & webUrl & "</a></div>"
                        return "Partial: Created note with HTML link (attachment method failed, using fallback)"
                    end try
                end tell
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
EOF

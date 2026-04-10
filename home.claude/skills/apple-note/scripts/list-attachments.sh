#!/bin/bash
# List all attachments in a note
# Shows: images, files, links embedded in the note

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
            set noteBody to body of theNote

            -- Parse for attachments
            set attachmentList to {}
            set links to {}
            set images to {}

            -- Extract img tags
            if noteBody contains "<img" then
                set imgCount to my countOccurrences(noteBody, "<img")
                if imgCount > 0 then
                    set end of images to "Found " & imgCount & " image(s)"
                end if
            end if

            -- Extract href links
            if noteBody contains "<a href" then
                set linkCount to my countOccurrences(noteBody, "<a href")
                if linkCount > 0 then
                    set end of links to "Found " & linkCount & " link(s)"
                end if
            end if

            -- Combine results
            set resultText to "Attachments in '" & noteName & "':" & return
            if count of images > 0 then
                repeat with imgInfo in images
                    set resultText to resultText & "  • " & imgInfo & return
                end repeat
            end if
            if count of links > 0 then
                repeat with linkInfo in links
                    set resultText to resultText & "  • " & linkInfo & return
                end repeat
            end if

            if (count of images) is 0 and (count of links) is 0 then
                set resultText to resultText & "  No attachments found"
            end if

            return resultText

        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run

on countOccurrences(txt, srch)
    set count to 0
    set startPos to 1
    repeat
        if txt contains srch then
            set startPos to (offset of srch in txt) + 1
            set txt to text startPos thru -1 of txt
            set count to count + 1
        else
            exit repeat
        end if
    end repeat
    return count
end countOccurrences
EOF

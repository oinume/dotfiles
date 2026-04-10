#!/bin/bash
# Export a note to a file (plain text or HTML)

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"
NOTE_NAME="$3"
OUTPUT_FILE="$4"
FORMAT="${5:-txt}"  # Options: txt, html

if [ -z "$NOTE_NAME" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Error: Note name and output file are required"
    echo "Usage: $0 [account] [folder] <note_name> <output_file> [format]"
    echo "Formats: txt (default), html"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" "$OUTPUT_FILE" "$FORMAT" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv
    set outputFile to item 4 of argv
    set exportFormat to item 5 of argv

    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            set noteBody to body of theNote
            set noteNamePlain to name of theNote

            -- Strip HTML for plain text export
            if exportFormat is "txt" then
                -- Basic HTML tag removal
                set noteBody to my replaceText(noteBody, "<div>", return)
                set noteBody to my replaceText(noteBody, "</div>", "")
                set noteBody to my replaceText(noteBody, "<br>", return)
                set noteBody to my replaceText(noteBody, "<b>", "")
                set noteBody to my replaceText(noteBody, "</b>", "")
                set noteBody to my replaceText(noteBody, "<i>", "")
                set noteBody to my replaceText(noteBody, "</i>", "")
                set noteBody to my replaceText(noteBody, "<h1>", "")
                set noteBody to my replaceText(noteBody, "</h1>", return)
                set noteBody to my replaceText(noteBody, "<h2>", "")
                set noteBody to my replaceText(noteBody, "</h2>", return)
                set noteBody to my replaceText(noteBody, "<h3>", "")
                set noteBody to my replaceText(noteBody, "</h3>", return)
                set noteBody to my replaceText(noteBody, "&quot;", "\"")
                set noteBody to my replaceText(noteBody, "&amp;", "&")
                set noteBody to my replaceText(noteBody, "&lt;", "<")
                set noteBody to my replaceText(noteBody, "&gt;", ">")
            end if

            -- Write to file with UTF-8 encoding
            set fileRef to open for access outputFile with write permission
            try
                set eof of fileRef to 0
                write noteBody to fileRef as «class utf8»
                close access fileRef
                return "Success: Exported note to '" & outputFile & "'"
            on error
                close access fileRef
                throw
            end try
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run

on replaceText(txt, srch, repl)
    set AppleScript's text item delimiters to srch
    set txtItems to text items of txt
    set AppleScript's text item delimiters to repl
    set txt to txtItems as string
    set AppleScript's text item delimiters to ""
    return txt
end replaceText
EOF

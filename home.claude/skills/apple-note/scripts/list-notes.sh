#!/bin/bash
# List all notes in a specific folder

ACCOUNT="${1:-iCloud}"
FOLDER="${2:-Notes}"

osascript - "$ACCOUNT" "$FOLDER" <<'EOF'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    tell application "Notes"
        try
            set noteList to every note in folder folName of account accName
            set noteInfo to {}
            repeat with nte in noteList
                set noteName to name of nte
                set noteMod to modification date of nte
                set noteBody to body of nte
                -- Safe preview extraction with length check
                set preview to ""
                if length of noteBody > 0 then
                    if length of noteBody > 100 then
                        set preview to text 1 thru 100 of noteBody
                    else
                        set preview to noteBody
                    end if
                end if
                -- Strip HTML tags and replace newlines for cleaner output
                set preview to my stripTags(preview)
                set preview to my replaceText(preview, return, " ")
                set end of noteInfo to noteName & " | " & (noteMod as string) & " | " & preview
            end repeat
            set AppleScript's text item delimiters to "\n"
            return noteInfo as string
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

on stripTags(txt)
    -- Simple HTML tag stripper - removes content between < and >
    set resultText to ""
    set inTag to false
    repeat with ch in characters of txt
        if ch is "<" then
            set inTag to true
        else if ch is ">" then
            set inTag to false
        else if inTag is false then
            set resultText to resultText & ch
        end if
    end repeat
    return resultText
end stripTags
EOF

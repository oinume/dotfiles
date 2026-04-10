#!/bin/bash
# Create a note with rich link preview using Shortcuts
# This method triggers Notes' built-in link preview engine
#
# Prerequisites:
# 1. Create a shortcut in macOS Shortcuts app named "CreateRichNote"
# 2. The shortcut should have: "Create Memo" action with content from "Shortcut Input"
#
# Usage: ./create-rich-link-via-shortcut.sh <note_title> <url>
# Example: ./create-rich-link-via-shortcut.sh "Apple Site" "https://www.apple.com"

NOTE_TITLE="$1"
URL="$2"

if [ -z "$NOTE_TITLE" ] || [ -z "$URL" ]; then
    echo "Error: Note title and URL are required"
    echo "Usage: $0 <note_title> <url>"
    exit 1
fi

# Method 1: Pass URL to shortcut which will create the note with preview
# The shortcut will handle the rich link generation
echo "$URL" | shortcuts run "CreateRichNote" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Success: Created note with rich link preview"
else
    echo "Error: Shortcut 'CreateRichNote' not found or failed to run"
    echo ""
    echo "To set up the shortcut:"
    echo "1. Open Shortcuts app on macOS"
    echo "2. Create new shortcut named 'CreateRichNote'"
    echo "3. Add action: 'Create Memo'"
    echo "4. Set content to 'Shortcut Input'"
    echo "5. Save the shortcut"
    exit 1
fi

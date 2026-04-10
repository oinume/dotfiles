#!/bin/bash
# Set up the required Shortcuts for rich link creation
# This script creates/updates the "CreateRichNote" shortcut

SHORTCUT_NAME="CreateRichNote"
SHORTCUT_PLIST="$HOME/Library/Shortcuts/$SHORTCUT_NAME.shortcut"

echo "Setting up '$SHORTCUT_NAME' shortcut..."
echo ""
echo "Due to macOS Shortcuts format complexity, please create manually:"
echo ""
echo "1. Open 'Shortcuts' app (快捷指令)"
echo "2. Click '+' to create new shortcut"
echo "3. Name it: '$SHORTCUT_NAME'"
echo "4. Add these actions:"
echo "   a. 'Receive' action with type: Text"
echo "   b. 'Create Memo' action:"
echo "      - Content: Shortcut Input"
echo "      - Folder: (select your desired folder)"
echo "5. Save the shortcut"
echo ""
echo "After setup, test with:"
echo "  echo 'https://www.apple.com' | shortcuts run '$SHORTCUT_NAME'"
echo ""

# Check if shortcut exists
if shortcuts list 2>/dev/null | grep -q "$SHORTCUT_NAME"; then
    echo "Shortcut '$SHORTCUT_NAME' already exists!"
    echo "Testing..."
    echo ""
    echo "https://www.example.com" | shortcuts run "$SHORTCUT_NAME"
else
    echo "Shortcut '$SHORTCUT_NAME' not found. Please create it manually."
fi

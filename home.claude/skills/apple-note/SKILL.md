---
name: apple-note
description: Interact with Apple Notes on macOS - create, read, edit, search, and list notes
---

# Apple Notes Skill

This skill enables you to interact with Apple Notes on macOS. You can create new notes, read existing notes, edit content, search for notes, and list folders/notes.

## Prerequisites

- macOS with Apple Notes app
- Notes must be synced with iCloud or stored locally
- Claude Code needs Accessibility permission to control Notes

## Available Scripts

All scripts are located in `scripts/` directory within this skill.

### List Accounts
```bash
./scripts/list-accounts.sh
```
Use this first to discover available account names (e.g., "iCloud", "On My Mac", or an email address).

### List Folders
```bash
./scripts/list-folders.sh [account]
```
Default account: `iCloud`

### List Notes
```bash
./scripts/list-notes.sh [account] [folder]
```
Defaults: account=`iCloud`, folder=`Notes`
Returns: Note name, modification date, and preview (first 100 chars)

### Get Note Content
```bash
./scripts/get-note.sh [account] [folder] <note_name>
```
Reads the full content of a specific note.

### Create Note
```bash
./scripts/create-note.sh [account] [folder] <note_title> [note_content]
```
Creates a new note. Content is automatically wrapped in `<div>` tags for proper HTML formatting.

### Update Note
```bash
./scripts/update-note.sh [account] [folder] <note_name> <new_content>
```
**Warning:** This performs a FULL replacement of the note content.
For appending: first use `get-note.sh`, combine the content, then call `update-note.sh`.

### Search Notes
```bash
./scripts/search-notes.sh [account] [folder] <keyword>
```
Searches both note names and bodies. Uses database-level filtering for fast results.

### Rename Note
```bash
./scripts/rename-note.sh [account] [folder] <old_name> <new_name>
```
Renames an existing note.

### Copy Note
```bash
./scripts/copy-note.sh [account] <source_folder> <note_name> <target_folder> [copy_name]
```
Creates a duplicate of a note in another folder. If `copy_name` is not specified, defaults to "original_name (copy)".

### Move Note
```bash
./scripts/move-note.sh [account] <source_folder> <note_name> <target_folder>
```
Moves a note from one folder to another.

### Delete Note
```bash
./scripts/delete-note.sh [account] [folder] <note_name>
```
**Warning:** This action cannot be undone! The note is permanently deleted.

## HTML Formatting

Apple Notes stores content as HTML. When creating or updating notes:
- Content is automatically wrapped in `<div>` tags
- To add line breaks, use `<br>` or separate paragraphs with `</div><div>`
- For multi-line content, consider using:
  ```
  <div>Line 1</div>
  <div>Line 2</div>
  <div>Line 3</div>
  ```

## Error Handling

All scripts return structured error messages starting with `Error:`.

Common errors:
- **Account not found**: Use `list-accounts.sh` to find the correct account name
- **Folder not found**: Use `list-folders.sh` to see available folders
- **Note not found**: Check the exact note name with `list-notes.sh`

## Permission Issues

If you see permission errors, the user needs to:
1. Open System Settings > Privacy & Security > Automation
2. Find Claude Code in the list
3. Enable "Notes" under Claude Code's permissions

## Best Practices

1. Always verify account/folder names before operations
2. Use `list-notes.sh` to get exact note names (case-sensitive)
3. For multi-line content, properly format with HTML
4. When updating, preserve existing HTML structure if needed
5. The `update-note.sh` script replaces ALL content - read first if you want to append

## Golden Rules for Claude Code

### 1. Always Discover Accounts First
Before any operation, run `list-accounts.sh` to discover the user's account names. Many users have accounts other than "iCloud" (e.g., "On My Mac", email addresses, or custom names).

```bash
./scripts/list-accounts.sh
```

### 2. Use Absolute Paths for File Operations
When calling `add-attachment.sh` or `export-note.sh`, always use absolute paths. If the user provides a relative path, convert it first using `realpath` or by constructing from the current working directory.

### 3. Attachment Functionality is Limited
**Important:** Apple Notes does NOT support true programmatic file attachments. `add-attachment.sh` creates a file:// link in the note. The link is clickable but requires manual handling to open the file. For actual file attachments, users should manually drag files from Finder to Notes.

### 4. Generate HTML Directly, Not Markdown
**Do NOT use shell-based Markdown converters.** They are fragile and cannot handle nested lists, multi-line code blocks, or complex formatting.

Instead, generate clean HTML directly:
```html
<div><h1>Title</h1></div>
<div><p>Paragraph text with <b>bold</b> and <i>italic</i>.</p></div>
<div><pre><code>Code block here</code></pre></div>
<div><ul><li>Item 1</li><li>Item 2</li></ul></div>
```

### 5. Always Wrap Content in `<div>` Tags
Apple Notes expects HTML content to be wrapped. Ensure your content starts with `<div>` and properly closes all tags.

### 6. Handle Special Characters Properly
All scripts use `argv` parameter passing, which safely handles quotes, backslashes, and special characters. You don't need to escape content - pass it as-is.

## Script Features

- **Safe parameter passing**: Uses `argv` to handle special characters (quotes, backslashes, etc.)
- **Structured output**: Returns newline-delimited results for easy parsing
- **Error handling**: All scripts include try-catch blocks
- **Performance**: Search uses `whose` clause for database-level filtering

## Link Preview Limitations

**Important:** Apple Notes' rich link previews (with thumbnails, titles, descriptions) cannot be created via AppleScript directly.

### Why HTML Links Don't Show Previews

When you manually paste a URL in Notes, the UI process asynchronously fetches Open Graph data and creates a `com.apple.notes.richlink` attachment. AppleScript's `set body` bypasses this process, so `<a href=URL>URL</a>` links appear as plain underlined text.

### Available Workarounds

1. **HTML Links (Default)** - Use `create-note.sh` with `<a href=url>url</a>`
   - Result: Underlined clickable link
   - Pros: Fully automated, works reliably
   - Cons: No rich preview card

2. **Shortcuts Method** - Requires manual setup
   - Create a shortcut named "CreateRichNote" in Shortcuts app
   - Use `create-rich-link-via-shortcut.sh`
   - Pros: Generates rich preview cards
   - Cons: Shows notification popup, requires one-time setup

3. **Attachment Method** - Experimental
   - Use `create-rich-link-attachment.sh`
   - Pros: Fully automated
   - Cons: Unreliable, often falls back to HTML links

### Recommendation

For most use cases, accept HTML links without preview. If rich previews are critical, use the Shortcuts method or manually paste URLs in Notes.

#!/bin/bash
# Create rich link using NSSharingService (JXA method)
# This opens the macOS share sheet to Notes, which creates perfect rich link previews
# Note: Requires manual interaction to save
#
# Usage: ./create-rich-link-jxa.sh <url>
# Example: ./create-rich-link-jxa.sh "https://www.apple.com"

URL="$1"

if [ -z "$URL" ]; then
    echo "Error: URL is required"
    echo "Usage: $0 <url>"
    exit 1
fi

# Create JXA script
JXA_SCRIPT="
function run(argv) {
    var urlString = argv[0];
    var url = $.NSURL.URLWithString(urlString);

    // Try to use sharing service
    var sharingServices = $.NSSharingService.sharingServicesForItems([url]);

    for (var i = 0; i < sharingServices.count(); i++) {
        var service = sharingServices.objectAtIndex(i);
        var serviceName = service.title();

        // Look for Notes sharing service
        if (serviceName.indexOf('Notes') !== -1 || serviceName.indexOf('备忘录') !== -1) {
            service.performWithItems([url]);
            return 'Opened share sheet for Notes - please save manually';
        }
    }

    return 'Error: Notes sharing service not found';
}
"

# Save to temp file and run
TEMP_SCRIPT=$(mktemp)
echo "$JXA_SCRIPT" > "$TEMP_SCRIPT"

osascript -l JavaScript "$TEMP_SCRIPT" "$URL"
RESULT=$?

rm "$TEMP_SCRIPT"

if [ $RESULT -ne 0 ]; then
    echo "Error: Failed to run JXA script"
    exit 1
fi

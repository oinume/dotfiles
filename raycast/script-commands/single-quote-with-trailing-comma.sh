#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title single-quote-with-trailing-comma
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description single-quote-with-trailing-comma
# @raycast.author Kazuhiro Oinuma
# @raycast.authorURL https://github.com/oinume

pbpaste | perl -pe "s/.*/'\$&',/"

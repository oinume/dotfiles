#!/bin/sh

set -eux

# Install gocomplete for bash completion of go command
# See: https://github.com/posener/complete
go install github.com/posener/complete/v2/gocomplete@latest

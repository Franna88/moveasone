#!/bin/bash

# This script handles paths with spaces in Xcode build phases
# It's a simple wrapper that ensures paths with spaces are correctly handled

# Remove any backslash escaping from the workspace path
export WORKSPACE_PATH="${WORKSPACE_PATH//\\/}"
echo "Running with workspace path: $WORKSPACE_PATH"

# Make sure we're in the workspace directory
cd "$WORKSPACE_PATH" || exit 1

# Run the command that was passed to this script
exec "$@" 
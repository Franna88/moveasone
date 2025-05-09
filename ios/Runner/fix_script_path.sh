#!/bin/bash

# This script properly escapes paths with spaces 
# It's meant to be used in Xcode build phases for Runner

# Get the escaped path to the project directory
PROJECT_DIR="$1"
if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

echo "Using project directory: $PROJECT_DIR"

# Run any commands that need proper path escaping here
# For example:
# "$PROJECT_DIR/scripts/some_script.sh"

# Exit successfully
exit 0 
#!/bin/bash

# This script handles paths with spaces by escaping them properly
# It's used to fix build issues in the iOS app

# If any command fails, exit immediately
set -e

# Escape any spaces in paths
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$WORKSPACE_DIR")"

echo "Using workspace directory: $WORKSPACE_DIR"
echo "Using project directory: $PROJECT_DIR"

# Run pod install with properly escaped paths
cd "$WORKSPACE_DIR"
pod install --verbose

echo "Pod installation completed successfully!" 
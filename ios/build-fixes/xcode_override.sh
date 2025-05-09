#!/bin/bash

# This is a wrapper script for xcode_backend.sh that properly handles paths with spaces

# Set up error handling
set -e

# Get current directory (where this script is located)
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Current directory: $CURRENT_DIR"

# Project directory (two levels up from this script)
PROJECT_DIR="$(cd "$CURRENT_DIR/../.." && pwd)"
echo "Project directory: $PROJECT_DIR"

# Create safe symlinks without spaces
SAFE_PATH="/tmp/moveasone_safe_path"
mkdir -p "$SAFE_PATH"

# If the original Flutter root path has spaces, create a symlink to a safe path
if [[ "$FLUTTER_ROOT" == *" "* ]]; then
  SAFE_FLUTTER_ROOT="$SAFE_PATH/flutter_root"
  echo "Creating safe symlink for Flutter root: $SAFE_FLUTTER_ROOT -> $FLUTTER_ROOT"
  rm -f "$SAFE_FLUTTER_ROOT"
  ln -sf "$FLUTTER_ROOT" "$SAFE_FLUTTER_ROOT"
  export FLUTTER_ROOT="$SAFE_FLUTTER_ROOT"
fi

# Print environment variables for debugging
echo "Current environment variables:"
echo "CONFIGURATION: $CONFIGURATION"
echo "PLATFORM_NAME: $PLATFORM_NAME"
echo "ARCHS: $ARCHS"
echo "EFFECTIVE_PLATFORM_NAME: $EFFECTIVE_PLATFORM_NAME"

# Set FLUTTER_TARGET_PLATFORM based on build configuration
if [[ "$EFFECTIVE_PLATFORM_NAME" == *simulator* ]]; then
  echo "Building for simulator"
  export FLUTTER_TARGET_PLATFORM="ios-simulator"
else
  echo "Building for device"
  export FLUTTER_TARGET_PLATFORM="ios"
fi

# Now we can safely call the original script
echo "Calling original xcode_backend.sh with args: $@"
exec "/bin/sh" "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" "$@" 
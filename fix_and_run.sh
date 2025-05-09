#!/bin/bash

set -e

# Create a clean directory without spaces in the path
CLEAN_DIR="$HOME/moveasone_temp"
echo "Setting up clean directory at $CLEAN_DIR"

# Remove old directory if it exists
if [ -d "$CLEAN_DIR" ]; then
  echo "Removing previous directory..."
  rm -rf "$CLEAN_DIR"
fi

# Create the directory
mkdir -p "$CLEAN_DIR"

# Copy only the essential files
echo "Copying project files..."
cp -R lib "$CLEAN_DIR/"
cp -R ios "$CLEAN_DIR/"
cp -R android "$CLEAN_DIR/"
cp -R assets "$CLEAN_DIR/" 2>/dev/null || true
cp -R fonts "$CLEAN_DIR/" 2>/dev/null || true
cp -R images "$CLEAN_DIR/" 2>/dev/null || true
cp pubspec.yaml "$CLEAN_DIR/"
cp pubspec.lock "$CLEAN_DIR/" 2>/dev/null || true

# Go to the clean directory
cd "$CLEAN_DIR"

# Clean up any previous build artifacts
echo "Cleaning previous builds..."
flutter clean

# Get dependencies
echo "Installing dependencies..."
flutter pub get

# Install iOS pods
echo "Installing iOS pods..."
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# Run on simulator
echo "Running on simulator..."
flutter run -d "iPhone 15" --debug 
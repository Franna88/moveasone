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

# Create build-fixes directory if not exists
mkdir -p ios/build-fixes

# Create a fix script for Xcode build phases
cat > ios/build-fixes/xcode_override.sh << 'EOF'
#!/bin/bash
# This script handles the Flutter Xcode build phases
set -e

# Print args for debugging
echo "Running xcode_override.sh with args: $@"

# Get the original Flutter script
FLUTTER_SCRIPT="${FLUTTER_ROOT}/packages/flutter_tools/bin/xcode_backend.sh"
echo "Using Flutter script at: $FLUTTER_SCRIPT"

# Execute the original script
/bin/sh "$FLUTTER_SCRIPT" "$@"
EOF

# Make the script executable
chmod +x ios/build-fixes/xcode_override.sh

# Update the project.pbxproj to use our script
echo "Updating Xcode project file to use our wrapper script..."
sed -i '' 's|/bin/sh "\$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh"|/bin/sh "${PROJECT_DIR}/build-fixes/xcode_override.sh"|g' ios/Runner.xcodeproj/project.pbxproj

# Update Swift version in the Podfile
echo "Updating Swift version compatibility in Podfile..."
cat > ios/Podfile << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'Runner.xcworkspace'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Set Swift version for compatibility
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # Add this to fix build issues
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
      
      # Fix Swift compatibility issues
      config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Fix Swift compiler flags
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end
EOF

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

# Set the correct Swift version in the build settings
echo "Creating Swift version configuration..."
cat > ios/SwiftVersion.xcconfig << 'EOF'
SWIFT_VERSION = 5.0
DEAD_CODE_STRIPPING = YES
ENABLE_BITCODE = NO
EOF

# Try building with no-codesign first
echo "Building for simulator with no-codesign..."
flutter build ios --debug --no-codesign --simulator

# Run on simulator
echo "Running on simulator..."
flutter run -d "iPhone 15" --debug 
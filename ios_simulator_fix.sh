#!/bin/bash

set -e

echo "===== iOS Swift Compiler Fix Script ====="

# Work directly in current directory
CURRENT_DIR="$(pwd)"
echo "Working in: $CURRENT_DIR"

# Create a temporary directory without spaces
TEMP_DIR="/tmp/moveasone_build"
echo "Setting up temporary directory at $TEMP_DIR"

# Clean up previous build
if [ -d "$TEMP_DIR" ]; then
  echo "Cleaning up previous temporary build..."
  rm -rf "$TEMP_DIR"
fi

# Create the directory and copy necessary files
mkdir -p "$TEMP_DIR"
echo "Copying essential project files..."
cp -R lib "$TEMP_DIR/"
cp -R ios "$TEMP_DIR/"
cp -R pubspec.yaml "$TEMP_DIR/"
cp -R pubspec.lock "$TEMP_DIR/" 2>/dev/null || true

# Copy assets if they exist
for dir in assets fonts images; do
  if [ -d "$dir" ]; then
    cp -R "$dir" "$TEMP_DIR/"
  fi
done

# Change to the temporary directory
cd "$TEMP_DIR"
echo "Now working in: $(pwd)"

# Fix Podfile to properly support Swift
echo "Creating an optimized Podfile..."
cat > ios/Podfile << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

# Prevent Cocoapods from embedding a second Flutter framework
install! 'cocoapods', :disable_input_output_paths => true

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
    
    # Fix Swift version and other build settings for all targets
    target.build_configurations.each do |config|
      # Swift version setting
      config.build_settings['SWIFT_VERSION'] = '5.0'
      
      # iOS deployment target
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # Exclude problematic architectures for simulator
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64e'
      
      # Build settings to fix common issues
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
      
      # Disable code signing for simulator builds
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      
      # Set Swift optimization level
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      
      # Apply podspec fixes for path issues
      xcconfig_path = config.base_configuration_reference&.real_path
      if xcconfig_path && File.exist?(xcconfig_path)
        begin
          xcconfig = File.read(xcconfig_path)
          # Fix DT_TOOLCHAIN_DIR references which can cause issues with spaces
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        rescue => e
          puts "Warning: Failed to modify xcconfig file: #{e.message}"
        end
      end
    end
  end
end
EOF

# Create a special shell script to handle build phases with spaces in paths
echo "Creating helper script for Xcode build phases..."
mkdir -p ios/Runner/Scripts
cat > ios/Runner/Scripts/build_phase_wrapper.sh << 'EOF'
#!/bin/bash
# Script to safely handle build phase commands with spaces in paths

# Log the command and arguments
echo "Running build phase with args: $@"

# Execute the command
exec "$@"
EOF
chmod +x ios/Runner/Scripts/build_phase_wrapper.sh

# Update AppFrameworkInfo.plist
echo "Updating AppFrameworkInfo.plist..."
cat > ios/Flutter/AppFrameworkInfo.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>App</string>
  <key>CFBundleIdentifier</key>
  <string>io.flutter.flutter.app</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>App</string>
  <key>CFBundlePackageType</key>
  <string>FMWK</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>CFBundleVersion</key>
  <string>1.0</string>
  <key>MinimumOSVersion</key>
  <string>13.0</string>
</dict>
</plist>
EOF

# Modify project.pbxproj to use the wrapper script
echo "Updating Xcode project configuration..."
sed -i '' 's|/bin/sh ".*xcode_backend.sh"|/bin/sh "${PROJECT_DIR}/Runner/Scripts/build_phase_wrapper.sh" "${FLUTTER_ROOT}/packages/flutter_tools/bin/xcode_backend.sh"|g' ios/Runner.xcodeproj/project.pbxproj

# Clean and get dependencies
echo "Cleaning flutter project..."
flutter clean
echo "Getting dependencies..."
flutter pub get

# Install pods
echo "Installing iOS pods..."
cd ios
rm -rf Pods Podfile.lock
pod deintegrate || true
pod install --verbose
cd ..

# Try to build for simulator
echo "Building for iOS simulator..."
flutter build ios --debug --no-codesign --simulator

# List available simulators
echo "Available simulators:"
xcrun simctl list devices | grep -i iphone

# Run on simulator
echo "Attempting to run on simulator..."
flutter run -d "iPhone 15" --debug 
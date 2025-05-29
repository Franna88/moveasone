#!/bin/bash

# Exit on any error
set -e

echo "==== Flutter iOS Simulator Runner ===="

# Create a symbolic link in /tmp without spaces
LINK_PATH="/tmp/moveasone"
CURRENT_DIR="$(pwd)"

echo "Creating a symbolic link without spaces..."
# Remove existing link if present
rm -f "$LINK_PATH"
# Create new symbolic link
ln -sf "$CURRENT_DIR" "$LINK_PATH"

# Change to the linked directory
cd "$LINK_PATH"
echo "Working in: $(pwd)"

# Fix the Podfile for better iOS build compatibility 
echo "Updating Podfile..."
cat > ios/Podfile << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

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
    
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
EOF

# Clean everything to start fresh
echo "Cleaning project..."
flutter clean

# Get dependencies
echo "Installing pub dependencies..."
flutter pub get

# Install Pods
echo "Installing iOS pods..."
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# List available simulators
echo "Available simulators:"
xcrun simctl list devices | grep -i iphone

# Run on simulator
echo "Running on iPhone 15 simulator..."
flutter run -d "iPhone 15"

# Note to user
echo "If 'iPhone 15' is not available, please choose another device from the list above"
echo "and run: flutter run -d \"DEVICE_NAME\"" 
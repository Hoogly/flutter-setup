#!/bin/bash

# Flutter Development Setup for macOS Apple Silicon
# Uses ASDF for version management instead of Homebrew

# Ensure zprofile exists
if [ ! -f ~/.zprofile ]; then
    touch ~/.zprofile
fi

source ~/.zprofile

echo '--- Installing Homebrew (for system dependencies) -----'
which -s brew
if [[ $? != 0 ]] ; then
    echo "homebrew not found... installing...."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
    source ~/.zprofile
    brew update
else
    echo "homebrew found.. skipping... "
fi

echo '--- Installing system dependencies -----'
# Install essential tools via Homebrew
brew install git jq curl wget

echo '--- Installing GitHub Desktop -----'
APP="/Applications/GitHub Desktop.app"
if [ -d "$APP" ]; then
    echo "$APP found... skipping...."
else
    echo "$APP not found... installing..."
    brew install --cask github
fi

echo '--- Installing Visual Studio Code -----'
APP="/Applications/Visual Studio Code.app"
if [ -d "$APP" ]; then
    echo "VS Code found... skipping...."
else
    echo "VS Code not found... installing..."
    brew install --cask visual-studio-code
    
    ENV_VAR='export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 
    source ~/.zprofile
    
    echo '--- Installing Visual Studio Code Flutter Extension -----'
    code --install-extension Dart-Code.flutter
fi

echo '--- Installing XCode Command Line Tools -----'
source ~/.zprofile
which g++
if [[ $? != 0 ]] ; then
    echo "xcode command line tools not found... installing...."
    xcode-select --install
    echo "Please complete the XCode installation in the popup window, then press any key to continue..."
    read -p "Press any key to continue after XCode installation is complete..."
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -license accept
    sudo xcodebuild -runFirstLaunch
else
    echo "xcode command line tools found.. skipping... "
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
fi

echo '--- Installing iOS development tools -----'
# Install CocoaPods via Homebrew (more reliable than gem install)
# This avoids Ruby version conflicts and sudo requirements
brew install cocoapods
brew install fastlane

echo '--- Installing Java 17 (latest LTS) -----'
source ~/.zprofile    
java_home=$(/usr/libexec/java_home)
if [[ -z $java_home ]] ; then
    echo "Java not found... installing Java 17..."
    brew install --cask zulu17
    ENV_VAR="export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 
    source ~/.zprofile
else
    echo "Java found.. skipping... "
fi

echo '--- Installing Android Studio -----'
source ~/.zprofile
APP="/Applications/Android Studio.app"
if [ -d "$APP" ]; then
    echo "Android Studio found... skipping...."
else
    echo "### IMPORTANT ####"
    echo "1. Download and install Android Studio from the web.."
    echo "2. Open Android Studio -> Preferences -> search 'sdk' -> Android SDK Command-line Tools"
    read -p "3. Once completed, press any key to proceed"

    ANDROID_HOME=$HOME/Library/Android/sdk
    COMMAND_LINE_TOOL_PATH=$ANDROID_HOME/cmdline-tools

    ENV_VAR='export ANDROID_HOME=$HOME/Library/Android/sdk'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    ENV_VAR='export PATH=$ANDROID_HOME/cmdline-tools/tools/bin/:$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    ENV_VAR='export PATH=$ANDROID_HOME/cmdline-tools/latest/bin/:$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    ENV_VAR='export PATH=$ANDROID_HOME/emulator/:$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    ENV_VAR='export PATH=$ANDROID_HOME/platform-tools/:$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 
    
    mkdir -p ~/.android && touch ~/.android/repositories.cfg

    source ~/.zprofile
    sdkmanager --install "platform-tools"
    sdkmanager --install "cmdline-tools;latest"
fi

echo '--- Installing ASDF Version Manager -----'
source ~/.zprofile
if [ ! -d "$HOME/.asdf" ]; then
    echo "ASDF not found... installing..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    
    # Add ASDF to shell
    echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zprofile
    echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zprofile
    source ~/.zprofile
else
    echo "ASDF found... skipping..."
fi

echo '--- Installing Flutter via ASDF -----'
source ~/.zprofile
# Add Flutter plugin to ASDF (official community plugin)
echo "Adding Flutter plugin to ASDF..."
asdf plugin-add flutter https://github.com/asdf-community/asdf-flutter.git || echo "Flutter plugin already exists"

# Install Dart SDK first (required for Flutter)
echo "Installing Dart SDK..."
asdf plugin-add dart https://github.com/patoconnor43/asdf-dart.git || echo "Dart plugin already exists"
asdf install dart stable
asdf global dart stable

# Install latest stable Flutter
echo "Installing latest stable Flutter..."
asdf install flutter stable
asdf global flutter stable

# Set FLUTTER_ROOT for IDE support
echo '--- Setting up Flutter environment variables -----'
FLUTTER_ROOT_VAR='export FLUTTER_ROOT="$(asdf where flutter)"'
grep -qxF "$FLUTTER_ROOT_VAR" ~/.zprofile || echo "$FLUTTER_ROOT_VAR" >> ~/.zprofile 
source ~/.zprofile

# Verify Flutter installation
echo '--- Verifying Flutter Installation -----'
flutter --version
flutter doctor

echo '--- Installing additional development tools -----'
# Install additional useful tools
brew install --cask android-studio
brew install --cask intellij-idea-ce

echo '--- Installing Ruby dependencies -----'
sudo arch -x86_64 gem install ffi

echo '--- Final verification -----'
echo "Checking Flutter installation..."
flutter --version
echo "Running Flutter doctor..."
flutter doctor

echo '--- Setup Complete! -----'
echo "✅ Flutter development environment is ready!"
echo ""
echo "📋 What was installed:"
echo "  • ASDF version manager"
echo "  • Dart SDK (latest stable)"
echo "  • Flutter SDK (latest stable)"
echo "  • Java 17 (latest LTS)"
echo "  • XCode Command Line Tools"
echo "  • Android Studio"
echo "  • VS Code with Flutter extension"
echo "  • CocoaPods for iOS development"
echo ""
echo "🔧 Useful commands:"
echo "  • asdf list flutter          # See installed Flutter versions"
echo "  • asdf install flutter 3.24.5 # Install specific Flutter version"
echo "  • asdf global flutter 3.24.5  # Switch to specific version"
echo "  • flutter doctor             # Check setup status"
echo ""
echo "🚀 You can now start developing Flutter apps!"

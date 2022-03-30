#!/bin/bash

#git config --local core.hooksPath .githooks/

if [ -f ~/.zprofile ]; then
    touch ~/.zprofile
fi

source ~/.zprofile
echo '--- Installing homebrew -----'
which -s brew
if [[ $? != 0 ]] ; then
    echo "homebrew not found... installing...."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)

    ENV_VAR='export PATH="/usr/local/bin:$PATH"'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    source ~/.zprofile
    brew update
    brew doctor
    
else
    echo "homebrew found.. skipping... "
fi

echo '--- Installing git -----'
which -s git
if [[ $? != 0 ]] ; then
    echo "git not found... installing...."
    brew install git
else
    echo "git found.. skipping... "
fi

echo '--- Installing GitHub Desktop -----'
APP="/Applications/GitHub Desktop.app"
if [ -d "$APP" ]; then
    echo "$APP found... skipping...."
else
    echo "$APP not found... installing..."
    brew install --cask github
fi

echo '--- Installing Visual Studio Code -----'
source ~/.zprofile
APP="/Applications/Visual Studio Code.app"
if [ -d "$APP" ]; then
    echo "VS Code found... skipping...."

    APP="/Applications/Visual Studio Code.app"
    if [ -d "$APP" ]; then
        echo "$APP found... skipping...."
    else
        echo "$APP not found... installing..."
        brew install --cask visual-studio-code
    fi
    
    ENV_VAR='export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    echo '--- Installing Visual Studio Code Flutter Extension -----'
    source ~/.zprofile
    code --install-extension Dart-Code.flutter
else
    echo "VS Code not found... installing..."

    APP="/Applications/Visual Studio Code.app"
    if [ -d "$APP" ]; then
        echo "$APP found... skipping...."
    else
        echo "$APP not found... installing..."
        brew install --cask visual-studio-code
    fi
    
    ENV_VAR='export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 

    echo '--- Installing Visual Studio Code Flutter Extension -----'
    source ~/.zprofile
    code --install-extension Dart-Code.flutter
fi

echo '--- Installing jq -----'
which -s jq
if [[ $? != 0 ]] ; then
    echo "jq not found... installing...."
    brew install jq
else
    echo "jq found.. skipping... "
fi

echo '--- Installing XCode -----'
source ~/.zprofile
which g++
if [[ $? != 0 ]] ; then
    echo "xcode not found... installing...."
    xcode-select --install
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -license
    sudo xcodebuild -runFirstLaunch
else
    echo "xcode found.. skipping... "
fi

which -s pod
if [[ $? != 0 ]] ; then
    echo "cocoapods not found... installing...."
    sudo gem install cocoapods
else
    echo "cocoapods found.. skipping... "
fi

echo '--- Installing Java 8 -----'
source ~/.zprofile    
java_home=$(/usr/libexec/java_home)
if [[ -z $java_home ]] ; then
    PACKAGE_NAME=zulu8.60.0.21-ca-jdk8.0.322-macosx_aarch64
    DOWNLOADED_FILE=~/Downloads/${PACKAGE_NAME}.zip
    UNZIP_FOLDER=~/Downloads/${PACKAGE_NAME}
    JAVA_DIR=/Library/Java/JavaVirtualMachines
    /bin/bash -c "$(curl -fsSL https://cdn.azul.com/zulu/bin/zulu8.60.0.21-ca-jdk8.0.322-macosx_aarch64.zip -o ${DOWNLOADED_FILE})"
    unzip $DOWNLOADED_FILE -d ~/Downloads
    sudo cp -a ${UNZIP_FOLDER}/zulu-8.jdk ${JAVA_DIR}

    ENV_VAR="export JAVA_HOME=${JAVA_DIR}/zulu-8.jdk/Contents/Home"
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 
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
    flutter doctor --android-licenses
fi

echo '--- Installing Flutter -----'
source ~/.zprofile
which -s flutter
if [[ $? != 0 ]] ; then
    echo "flutter not found... installing...."
    brew install --cask flutter
    ENV_VAR='export PATH="`pwd`/flutter/bin:$PATH"'
    grep -qxF "$ENV_VAR" ~/.zprofile || echo "$ENV_VAR" >> ~/.zprofile 
else
    echo "flutter found.. skipping... "
fi


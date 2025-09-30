# Setup Flutter Dev
## mac - silicon (M1/M2/M3 - ARM)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Hoogly/flutter-setup/master/scripts/macos-silicon.sh)"
```
The script will install the following:
* Homebrew (for system dependencies)
* Git
* GitHub Desktop
* VS Code (with Flutter extension)
* XCode Command Line Tools
* Java 17 (Zulu - latest LTS)
* CocoaPods (for iOS/macOS development)
* Android Studio
	* manual installation with instruction on how to add command-line tools
* ASDF Version Manager
* Flutter (via ASDF - latest stable)
	* Supports multiple Flutter versions
	* Easy version switching with `asdf global flutter <version>`
	
# Screen
# ======

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the downlaods.
defaults write com.apple.screencapture location "$HOME/Downloads/"

# Sound
# =====

# Disable the sound effects on boot
# sudo nvram SystemAudioVolume=0

# Trackpad, mouse, keyboard, Bluetooth accessories, and input
# ===========================================================

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write com.apple.AppleMultitouchTrackpad Clicking 1

# Finder
# ======

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show the ~/Library folder
chflags nohidden ~/Library
function showdesktop -d "Show all icons on the macOS desktop"
    defaults write com.apple.finder CreateDesktop true
    killall Finder
end

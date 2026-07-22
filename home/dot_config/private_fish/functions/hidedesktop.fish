function hidedesktop -d "Hide all icons on the macOS desktop"
    defaults write com.apple.finder CreateDesktop false
    killall Finder
end

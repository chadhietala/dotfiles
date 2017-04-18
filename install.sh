echo 'Provisioning...'

echo 'Changing editor to fish: `chsh -s /bin/fish`'
chsh -s /bin/fish

git clone --recursive git://github.com/chadhietala/dotfiles.git
cd dotfiles
sudo bash symlink-dotfiles.sh

echo 'Provisioning $(hostname)'

echo 'Changing editor to zsh: `chsh -s /bin/zsh`'
chsh -s /bin/zsh

dir="$HOME/Developer/chietala"
theme="$dir/oh-my-zsh/chietala.zsh-theme"
mkdir -p $dir
cd $dir

# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh

# Copy my theme
cp theme "$HOME/.oh-my-zsh/themes/"

git clone git://github.com/chadhietala/dotfiles.git
cd dotfiles
sudo bash symlinks-dotfiles.sh
echo 'Provisioning $(hostname)'

echo 'Changing editor to zsh: `chsh -s /bin/zsh`'
chsh -s /bin/zsh

dir="$HOME/Developer/chietala"
theme="$dir/oh-my-zsh/chietala.zsh-theme"
mkdir -p $dir
cd $dir

# Install NVM
curl https://raw.githubusercontent.com/creationix/nvm/v0.19.0/install.sh | bash
source ~/.zshrc
nvm install 0.10.33
nvm alias default 0.10.33

# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh

# Copy my theme
cp theme "$HOME/.oh-my-zsh/themes/"
cd "$HOME/.oh-my-zsh"
git add .
git commit -m "adding theme"
cd $dir

git clone --recursive git://github.com/chadhietala/dotfiles.git
cd dotfiles
sudo bash symlinks-dotfiles.sh
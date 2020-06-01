#!/bin/bash
# Zsh Setup
# Assumes a debian or ubuntu base OR WSL


# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup Plugins
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "Now go add zsh-autosuggestions under ~/.zshrc plugins section"

# Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "Now go add zsh-syntax-highlighting under ~/.zshrc plugins section"

# Add additional theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'Now go change theme to ZSH_THEME="powerlevel10k/powerlevel10k" under ~/.zshrc plugins section'

# Download Font
cd /tmp/
wget https://github.com/microsoft/cascadia-code/releases/download/v2005.15/CascadiaCode_2005.15.zip
unzip CascadiaCode_2005.15.zip

# Add the plugins to zsh config
cp zshrc ~/.zshrc

# [Optional] Uncomment if you want powerline
# sudo apt-get install fonts-powerline

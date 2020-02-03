#!/bin/bash
# Zsh Setup
# Assumes a debian or ubuntu base


# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup Plugins
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "Now go add zsh-autosuggestions under ~/.zshrc plugins section"

# Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "Now go add zsh-syntax-highlighting under ~/.zshrc plugins section"

# Add the plugins to zsh config
# sed -i '/plugins=\{git/zsh-autosuggestions' ~/.zshrc

# [Optional] Uncomment if you want powerline
# sudo apt-get install fonts-powerline

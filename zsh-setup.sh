#!/bin/bash
# Zsh Setup
# Assumes a debian or ubuntu base OR WSL


# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup Plugins
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/" ~/.zshrc

# Add additional theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'Now go change theme to ZSH_THEME="powerlevel10k/powerlevel10k" under ~/.zshrc plugins section'

# Download Font
cd /tmp/
wget https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip
unzip CascadiaCode-2407.24.zip

# Install modern CLI tools
echo "Installing modern CLI tools"
sudo apt-get install -y bat fzf eza
# bat is installed as 'batcat' on Ubuntu/Debian - create symlink
mkdir -p ~/.local/bin && ln -sf /usr/bin/batcat ~/.local/bin/bat

# Install zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install fzf key bindings
~/.fzf/install --all --no-bash --no-fish 2>/dev/null || true

# [Optional] Uncomment if you want additional aliases in zsh config
# cp zshrc ~/.zshrc


# [Optional] Uncomment if you want powerline
# sudo apt-get install fonts-powerline

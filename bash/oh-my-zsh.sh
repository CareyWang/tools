#!/bin/bash

sudo apt update
sudo apt install zsh -y 
chsh -s /bin/zsh 

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone  https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone  https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone  https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# POWERLEVEL9K_MODE="nerdfont-complete"
# ZSH_THEME="powerlevel9k/powerlevel9k"

# ZSH_THEME="ys"
# plugins=(
#   extract zsh-autosuggestions zsh-syntax-highlighting
# )

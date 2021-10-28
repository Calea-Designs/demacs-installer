#!/bin/sh

# Bespoke script by CD for installing Doom-emacs on a fresh Endeavor OS install.

# None of the config adjustments are automated, if you need to change what modules to enable
# and install dependencies for, that must be written in from the ground up.

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing emacs itself and base pre-requisites
sudo pacman -S -q --noconfirm --needed git emacs ripgrep fd

echo installing doom-emacs
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
PATH="$HOME/.emacs.d/bin:$PATH"

mkdir ~/.doom.d

cp ~/.emacs.d/init.example.el ~/.doom.d/init.el
cp ~/.emacs.d/core/templates/config.example.el ~/.doom.d/config.el
cp ~/.emacs.d/core/templates/packages.example.el ~/.doom.d/packages.el

# You might want to edit ~/.doom.d/init.el here and make sure you only have the
# modules you want enabled.

# My init changes
sed -i '/minimap/s/;;//' ~/.doom.d/init.el
sed -i '/tabs/s/;;//' ~/.doom.d/init.el
sed -i '/word-wrap/s/;;//' ~/.doom.d/init.el
sed -i '/eshell/s/;;//' ~/.doom.d/init.el
sed -i '/vterm/s/;;//' ~/.doom.d/init.el
sed -i '/csharp/s/;;//' ~/.doom.d/init.el
sed -i '/lua/s/;;//' ~/.doom.d/init.el
sed -i '/python/s/;;//' ~/.doom.d/init.el
sed -i '/calendar/s/;;//' ~/.doom.d/init.el

# My package installs
echo '(package! evil-tutor)' | tee -a ~/.doom.d/packages.el > /dev/null

# My config changes
sed -i '/doom-one/s/doom-one/doom-manegarm/' ~/.doom.d/config.el

# Time to install the module dependencies

echo installing lang pre-reqs
sudo pacman -S -q --needed --noconfirm mono # C Sharp
sudo pacman -S -q --needed --noconfirm python-isort python-pipenv python-pytest python-nose # Python
sudo pacman -S -q --needed --noconfirm shellcheck # Shell
sudo pacman -S -q --needed --noconfirm pandoc # Markdown

# Synchronize doom and build the env
doom sync
doom env

# install the icon fonts Doom uses:
emacs --batch -f all-the-icons-install-fonts

# Add doom to our PATH so we can call it from anywhere
echo adding doom command to the terminal
echo 'PATH="$HOME/.emacs.d/bin:$PATH"' | tee -a .bashrc > /dev/null
PATH=”$HOME/.emacs.d/bin:$PATH”

# See how we did!
echo running the doctor
doom doctor

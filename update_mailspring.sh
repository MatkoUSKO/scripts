mkdir -p resources
cd resources
git clone https://aur.archlinux.org/mailspring.git
cd mailspring
killall -9 mailspring
makepkg -si
cd ..
rm -rf mailspring

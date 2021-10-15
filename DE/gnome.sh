#!/bin/bash

# Paru install
echo
echo "Installing Paru"
echo
cd ~/Downloads
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -sri
cd ~ && rm -rf Downloads/paru

echo
echo "Updating Mirrorlist"
echo
sudo reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist
echo
echo "Updating packages"
echo
sudo pacman -Syyu

echo
echo "Enabling firewall services"
echo
sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload
sudo virsh net-autostart default

echo
echo "Installing Gnome DESKTOP and fonts packages"
echo
sudo pacman -S --noconfirm xorg gdm gnome gnome-extra gnome-tweaks arc-gtk-theme arc-icon-theme dina-font tamsyn-font bdf-unifont ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font ttf-junicode adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji

echo
echo "Enabling GDM service"
echo
sudo systemctl enable gdm

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot

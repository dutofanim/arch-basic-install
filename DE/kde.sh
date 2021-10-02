#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Sy

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

git clone https://github.com/Morganamilo/paru.git $HOME/Downloads
cd $HOME/Downloads/paru/
makepkg -si --noconfirm
cd .. && rm -rf paru

sudo pacman -S --noconfirm xorg sddm plasma kde-applications firefox simplescreenrecorder obs-studio vlc papirus-icon-theme kdenlive materia-kde

sudo systemctl enable sddm
sudo systemctl enable --now system76-power
sudo system76-power graphics integrated
sudo systemctl enable --now auto-cpufreq
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot

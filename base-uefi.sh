#!/bin/bash

# Variables definition
LOCALE="en_US"
HOST_NAME="arch"
KEY_MAP="br-abnt2"
USER_NAME="du"
USER_PASSWORD=""

# Functions definition
ask_question() {
    read -r -p $'\033[1;34m'"$* "$'\033[0m' var
    echo "${var}"
}

function ask_locale {
    local tmp
    tmp="$(ask_question "Locale (default: ${LOCALE})")"
    if [ -n "${tmp}" ]; then
        if [[ "${tmp}" = "${tmp%.*}" ]]; then
            LOCALE="${tmp}.UTF-8"
        else
            LOCALE="${tmp}"
        fi
    fi
}

function ask_hostname {
    local tmp
    tmp="$(ask_question "Hostname (default: ${HOST_NAME})")"
    if [ -n "${tmp}" ]; then
        HOST_NAME="${tmp}"
    else
        show_info "Defaulting hostname to ${HOST_NAME}."
    fi
}

function ask_keymap {
    local tmp
    tmp="$(ask_question "KEYMAP (default: ${KEY_MAP})")"
    if [ -n "${tmp}" ]; then
        KEY_MAP="${tmp}"
    else
        show_info "Defaulting keymap to ${KEY_MAP}."
    fi
}

function ask_username {
    local tmp
    tmp="$(ask_question "User name (default: ${USER_NAME})")"
    if [ -n "${tmp}" ]; then
        USER_NAME="${tmp}"
    else
        show_info "Defaulting user name to ${USER_NAME}."
    fi

    stty -echo
    tmp="$(ask_question "User password")"
    stty echo
    echo
    if [ -n "${tmp}" ]; then
        USER_PASSWORD="${tmp}"
    else
        show_error "ERROR: no password given."
        exit 3
    fi
}

function add_user {
    useradd -m -c "${USER_NAME[@]^}" "${USER_NAME}" -s /bin/bash
    usermod -aG wheel,"${USER_NAME}" "${USER_NAME}"
    echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

    sed -e "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers |
        EDITOR=tee visudo >/dev/null

    # disable root account
    passwd -l root
}

# Bash Commands
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

ask_locale
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}" >/etc/locale.conf
ask_keymap
echo -e "${KEY_MAP}" >/etc/vconsole.conf
ask_hostname
echo -e "${HOST_NAME}" >/etc/hostname

echo -e "127.0.0.1\tlocalhost \n::1 \t\tlocalhost \n127.0.1.1\tarchGDM.localdomain\tarchGDM" >>/etc/hosts

# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub grub-btrfs efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font udisks2 zip p7zip

# pacman -S --noconfirm xf86-video-amdgpu # If you have an AMDGPU
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

ask_username
add_user

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

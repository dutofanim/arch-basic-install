# Arch Basic Install Commands-Script

In this repository you will find packages-scripts for the base install of Arch Linux and the Gnome, KDE, Cinnamon and Xfce desktop environments. More to come for Windows Managers soon.
Modify the packages to your liking, make the script executable with chmod +x scriptname and then run with ./scriptname.
A script for the base install on MBR/Legacy will be available soon.
Remember that the first part of the Arch Linux install is manual, that is you will have to partition, format and mount the disk yourself. Install the base packages and make sure to inlcude git so that you can clone the repository in chroot.

A small summary:

1. If needed, load your keymap with `loadkeys`
2. Refresh the servers with:

	```bash
    pacman -Syy
	```

3. Partition the disk
4. Format the partitions
5. Mount the partitions
6. Install the base packages into `/mnt` with:

	```bash
    pacstrap /mnt base linux linux-firmware git vim intel-ucode (or amd-ucode)
	```

7. Generate the `FSTAB` file with:

	```bash
    genfstab -U /mnt >> /mnt/etc/fstab
	```

8. Chroot in with:

	```bash
    arch-chroot /mnt
	```

9. Download the git repository with:

	```bash
    git clone https://github.com/dutofanim/arch-basic-install.git
	```

10. Move to the new directory: 

	```bash
    cd arch-basic-install
	```

11. Give execute permission to script file:

	```bash
    chmod +x install-uefi.sh
	```

12. Execute the script:

	```bash
    ./install-uefi.sh
	```

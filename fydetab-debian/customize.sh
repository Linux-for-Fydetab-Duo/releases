#! /bin/bash

chroot=$1
pkgs="grub-efi-arm64 initramfs-tools linux-headers-6.1.0-1023-rockchip linux-image-6.1.0-1023-rockchip linux-modules-6.1.0-1023-rockchip mali-g610-firmware fydetabduo-post-install kmod"
run_in_chroot() {
    arch-chroot $chroot /bin/bash -c "$1"
}

echo "Setting up the system"

# deb [trusted=yes] https://deb-mirror.fydeos.com/fydetab/ bookworm main
echo "deb [trusted=yes] https://deb-mirror.fydeos.com/fydetab/ bookworm main" > $chroot/etc/apt/sources.list.d/fydetab.list

# Set up APT pinning for the repository
cat <<EOF > $chroot/etc/apt/preferences.d/fydetab
Package: *
Pin: origin deb-mirror.fydeos.com
Pin-Priority: 1001
EOF

password=$(openssl passwd -6 debian) # Password is "debian" (without quotes) 

run_in_chroot "apt update"
run_in_chroot "apt install -y $pkgs"
run_in_chroot "apt upgrade -y"
run_in_chroot "groupadd -g 1001 debian"
run_in_chroot "useradd -m -u 1001 -g 1001 -G sudo -s /bin/bash --password='$password' debian"

run_in_chroot "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen"
run_in_chroot "locale-gen"
run_in_chroot "update-locale LANG=en_US.UTF-8"

run_in_chroot "apt clean"
run_in_chroot "apt autoclean"
run_in_chroot "systemctl enable resizefs"
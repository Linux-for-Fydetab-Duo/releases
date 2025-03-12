chroot=$1
pkgs="grub-efi-arm64 initramfs-tools linux-headers-6.1.0-1023-rockchip linux-image-6.1.0-1023-rockchip linux-modules-6.1.0-1023-rockchip mali-g610-firmware fydetabduo-post-install kmod systemd-timesyncd"
run_in_chroot() {
    arch-chroot $chroot /bin/bash -c "$1"
}

echo "Setting up the system"


cat <<EOF > $chroot/etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF


cat <<EOF >> $chroot/etc/hosts
127.0.0.1	debian-ftd
EOF

run_in_chroot "wget -O - https://deb-mirror.fydeos.com/fydetab/key.gpg | gpg --dearmor -o /usr/share/keyrings/fydetab-archive-keyring.gpg"

# deb [signed-by=/usr/share/keyrings/fydetab-archive-keyring.gpg] https://deb-mirror.fydeos.com/fydetab bookworm main
echo "deb [signed-by=/usr/share/keyrings/fydetab-archive-keyring.gpg] https://deb-mirror.fydeos.com/fydetab bookworm main" > $chroot/etc/apt/sources.list.d/fydetab.list


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
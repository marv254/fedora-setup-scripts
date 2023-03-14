#!/bin/bash
#execute as a root user
dnf update && dnf upgrade -y

#install needed dependencies
dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig

#disable nouveau
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
GRUB_CMDLINE_LINUX="rhgb quiet rd.driver.blacklist=nouveau nvidia-drm.modeset=1"
grub2-mkconfig -o /boot/grub2/grub.cfg

#Remove xorg-x11-drv-nouveau
dnf remove xorg-x11-drv-nouveau

#Generate initramfs
#Backup old initramfs nouveau image 
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img

# Create new initramfs image 
dracut /boot/initramfs-$(uname -r).img $(uname -r)

systemctl set-default multi-user.target
reboot

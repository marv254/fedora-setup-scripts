#!/bin/bash
#execute as root user
#make NVIDIA install executable
chmod u+x /home/marv_k254/Downloads/NVIDIA-Linux-*.run
bash /home/marv_k254/Downloads/NVIDIA-Linux-*.run
dnf install vdpauinfo libva-vdpau-driver libva-utils
systemctl set-default graphical.target
reboot

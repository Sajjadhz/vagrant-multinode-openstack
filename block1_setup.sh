#! /bin/sh

cp /vagrant/block1_interfaces /etc/network/interfaces
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub


reboot

#!/bin/sh

sudo mkdir /media/iso
sudo mount -o loop VBoxGuestAdditions_*.iso /media/iso
sudo /media/iso/VBoxLinuxAdditions.run

mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 ~/.ssh/authorized_keys
chown -R ubuntu ~/.ssh
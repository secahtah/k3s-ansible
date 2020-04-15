# manual-shit.sh
# 14 April 2020 - secahtah
#
#   This does the base shit that I haven't had time to Ansible yet.
#   We assume the raspberri pi is the default install at this point
#   But you've configured networking, disabled the damned desktop,
#   and enabled ssh.

# Set hostname variable
export NEWHOSTNAME="k3s-server"

# set the hostname
hostnamectl set-hostname $NEWHOSTNAME

# fix /etc/hosts entries after renaming the host
#   Source:
#   https://linuxize.com/post/how-to-use-sed-to-find-and-replace-string-in-files/
sudo sed -i 's/raspberrypi/$NEWHOSTNAME/g' /etc/hosts

# set static address on it
#? Nevermind. My router does this via DHCP. Screw it

# create the directory to mount NFS
sudo mkdir /mnt/ssd

# Fix permissions BEFORE mounting it
#? Still doesn't fucking work
sudo chown -R pi:pi /mnt/ssd/

# add NFS to /etc/fstab
#? Also doesn't fucking work, fix me
#  The NFS won't mount because the Pi's wifi comes up after it tries to mount
#  the NFS
sudo echo "10.50.0.10:/mnt/gihugic/k3s   /mnt/ssd   nfs    rw  0  0" >> /etc/fstab

# 
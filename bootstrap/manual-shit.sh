# manual-shit.sh
# 14 April 2020 - secahtah
#
#   This does the base shit that I haven't had time to Ansible yet.
#   We assume the raspberri pi is the default install at this point
#   But you've configured networking, disabled the damned desktop,
#   and enabled ssh.
#? TODO: Move all this crap to ansible except the setup of ansible itself

# On the Ansible server, install these or you can't do Ansible or the key transfer
sudo apt-get install ansible
sudo apt-get install sshpass

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
#  Note: do sudo raspi-config, do boot options, enable "wait until networking"
#  or run the below
#? FIXME: Test this 
sudo mkdir -p /etc/systemd/system/dhcpcd.service.d/
#? This doens't work, you have to for some reason ACTUALLY run it as root
sudo cat > /etc/systemd/system/dhcpcd.service.d/wait.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/lib/dhcpcd5/dhcpcd -q -w
EOF
#? NOTE: Make sure you can write to the NFS Mount; in FreeNAS I had to 
#        set the Map user to root, and Map group to wheel. 
sudo echo "10.50.0.10:/mnt/gihugic/k3s/   /mnt/ssd   nfs    rw,hard,intr,rsize=8192,wsize=8192,timeo=14  0  0" >> /etc/fstab

# 
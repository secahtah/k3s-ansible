# manual-shit.sh
# 14 April 2020 - secahtah
#
#   This does the base shit that I haven't had time to Ansible yet.
#   We assume the raspberri pi is the default install at this point
#   But you've configured networking, disabled the damned desktop,
#   and enabled ssh.

# set the hostname
#? make variable
hostnamectl set-hostname k3s-server

# fix /etc/hosts entries after renaming the host
#? replace raspberry with k3s-server
#? make variable

# set static address on it

# add NFS to /etc/fstab

# 
# manual-shit.sh
# 14 April 2020 - secahtah
#
#   This does the base shit that I haven't had time to Ansible yet.
#   We assume the raspberri pi is the default install at this point
#   But you've configured networking, disabled the damned desktop,
#   and enabled ssh.
#? TODO: Move all this crap to ansible except the setup of ansible itself

# On the Ansible server, install these or you can't do Ansible or the key transfer
sudo apt-get install git
sudo apt-get install ansible
sudo apt-get install sshpass

# On any device that has to be on a network not currently fed the PiHole as its DNS:
sudo echo "static domain_name_servers=10.50.0.50" >> /etc/dhcpcd.conf
sudo service dhcpcd restart
sudo systemctl daemon-reload

# Now run the playbook
#   If you have a device that bitches about the password, use the -k option below
ansible-playbook -i inventory add-ssh-user.yml -k

# Set hostname variable
export NEWHOSTNAME="sd-jump-01"

# set the hostname
sudo hostnamectl set-hostname $NEWHOSTNAME

# fix /etc/hosts entries after renaming the host
#   Source:
#   https://linuxize.com/post/how-to-use-sed-to-find-and-replace-string-in-files/
sudo sed -i 's/raspberrypi/$NEWHOSTNAME/g' /etc/hosts

# set static address on it
#? Nevermind. My router does this via DHCP. Screw it

# create the directory to mount NFS
sudo mkdir /mnt/ssd

# Fix permissions BEFORE mounting it
sudo chown -R pi:pi /mnt/ssd/

# add NFS to /etc/fstab
sudo echo "10.50.0.10:/mnt/gihugic/k3s/   /mnt/ssd   nfs    rw,hard,intr,rsize=8192,wsize=8192,timeo=14  0  0" >> /etc/fstab

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

# 



# - name: Download the custom resource definition for cert manager
#   get_url:
#     url: https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml
#     dest: /tmp/00-crds.yaml
#     mode: '0777'
#   when: 
#     - ((k3s_installed == false) or (force == true))
#   tags:
#   - k3s_support

# - name: Install custom resource definition for cert manager
#   #? can this be done via the k8s module?  Not clear if that's just kubectl under the hood
#   # looks like it can, trying that out - 
#   # kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml
#   k8s:
#     state: present
#     api_version: v1
#     apply: yes
#     validate:
#       fail_on_error: yes
#       strict: no
#     resource_definition: "{{ lookup('file', '/tmp/00-crds.yaml ')}}"
#   when: 
#     - ((k3s_installed == false) or (force == true))
#   tags:
#   - k3s_support

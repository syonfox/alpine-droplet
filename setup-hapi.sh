#!/bin/sh

# Enable openssh server
rc-update add sshd default

echo ''
echo '#`###########################################################################################'
echo '## Networking  (eth0 dhcp, eth1 dhcp)' this is how do reserved ips work
echo '##############`##############################################################################'


# Configure networking
cat > /etc/network/interfaces <<-EOF
iface lo inet loopback
iface eth0 inet dhcp
iface eth1 inet dhcp

EOF

ln -s networking /etc/init.d/net.lo
ln -s networking /etc/init.d/net.eth0
ln -s networking /etc/init.d/net.eth1

rc-update add net.eth0 default
rc-update add net.lo boot
rc-update add net.eth1 boot

# Create root ssh directory
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Grab config from DigitalOcean metadata service
cat > /bin/do-init <<-EOF
#!/bin/sh
resize2fs /dev/vda
wget -T 5 http://169.254.169.254/metadata/v1/hostname    -q -O /etc/hostname
wget -T 5 http://169.254.169.254/metadata/v1/public-keys -q -O /root/.ssh/authorized_keys
hostname -F /etc/hostname
chmod 600 /root/.ssh/authorized_keys
rc-update del do-init default
exit 0
EOF

# Create do-init OpenRC service
cat > /etc/init.d/do-init <<-EOF
#!/sbin/openrc-run
depend() {
    need net.eth0
}
command="/bin/do-init"
command_args=""
pidfile="/tmp/do-init.pid"
EOF

# Make do-init and service executable
chmod +x /etc/init.d/do-init
chmod +x /bin/do-init

# Enable do-init service
rc-update add do-init default



echo ''
echo '############################################################################################'
echo '## Base Packages'
echo '############################################################################################'
apk add haproxy git nano nodejs npm certbot wireguard-tools-wg wget
apk add squashfs-tools
apk add singularity singularity-bash-completion singularity-doc --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
chmod 755 /bin/sh
apk add debootstrap


echo ''
echo '############################################################################################'
echo '## SSH Policy (.policy_ssh.sh)'
echo '############################################################################################'

. policy_ssh.sh

echo ''
echo '############################################################################################'
echo '## Firewall Policy (.policy_firewall.sh)'
echo '############################################################################################'

. policy_firewall.sh

echo ''
echo '############################################################################################'
echo '## MOTO'
echo '############################################################################################'

. policy_motd.sh

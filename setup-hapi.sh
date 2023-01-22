#!/bin/sh

# Enable openssh server
rc-update add sshd default
############################################################################################
## Networking
############################################################################################


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




############################################################################################
## Base Packages
############################################################################################
apk add haproxy git nano npm certbot wireguard-tools-wg wget
apk add squashfs-tools
apk add singularity singularity-bash-completion singularity-doc --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
chmod 755 /bin/sh
apk add debootstrap




############################################################################################
## SSH Policy
############################################################################################

./policy_ssh.sh

############################################################################################
## Firewall Policy
############################################################################################

./policy_firewall.sh


############################################################################################
## MOTO
############################################################################################


echo '#!/bin/sh' > /etc/profile.d/motd.sh
echo 'lastlogins=$(last)' >> /etc/profile.d/motd.sh
#echo 'load=$(uptime)' >> /etc/profile.d/motd.sh
echo 'uptime=$(uptime)' >> /etc/profile.d/motd.sh
echo 'mem=$(free -m)' >> /etc/profile.d/motd.sh
echo 'pkgs=$(apk list -Iv)' >> /etc/profile.d/motd.sh
echo 'procs=$(ps aux)' >> /etc/profile.d/motd.sh
echo 'sshprocs=$(ps aux| grep sshd)' >> /etc/profile.d/motd.sh

echo 'date=$(date)' >> /etc/profile.d/motd.sh
echo 'security=$(netstat)' >> /etc/profile.d/motd.sh
echo 'netstat=$(netstat -plntu)' >> /etc/profile.d/motd.sh
#echo 'cpu_load=$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6)' >> /etc/profile.d/motd.sh
echo 'num_processes=$(ps -e | wc -l)' >> /etc/profile.d/motd.sh
echo 'cat > /etc/motd << EOD' >> /etc/profile.d/motd.sh

echo 'Installed Packages:' >> /etc/profile.d/motd.sh
echo '$pkgs' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
#echo 'Critical Security Updates:' >> /etc/profile.d/motd.sh
#echo '$security' >> /etc/profile.d/motd.sh
#echo '' >> /etc/profile.d/motd.sh
echo 'Current Running Processes:' >> /etc/profile.d/motd.sh
echo '$procs' >> /etc/profile.d/motd.sh

echo 'Welcome to HAPI Alpine host! Above are running processes and installed software' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'Last 4 Logins:' >> /etc/profile.d/motd.sh
echo '$lastlogins' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'System Load and Disk Usage:' >> /etc/profile.d/motd.sh
#echo '$load' >> /etc/profile.d/motd.sh
#echo '' >> /etc/profile.d/motd.sh
echo 'System Uptime:' >> /etc/profile.d/motd.sh
echo '$uptime' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'Memory Usage:' >> /etc/profile.d/motd.sh
echo '$mem' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'Active Netstats:' >> /etc/profile.d/motd.sh
echo '$security' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'Listening Ports:' >> /etc/profile.d/motd.sh
echo '$netstat' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
#echo 'CPU Load:' >> /etc/profile.d/motd.sh
#echo '$cpu_load' >> /etc/profile.d/motd.sh
#echo '' >> /etc/profile.d/motd.sh
echo 'Number of Running Processes:' >> /etc/profile.d/motd.sh
echo '$num_processes' >> /etc/profile.d/motd.sh
echo '' >> /etc/profile.d/motd.sh
echo 'Information updated on:$date' >> /etc/profile.d/motd.sh
echo 'EOD' >> /etc/profile.d/motd.sh



chmod +x /etc/profile.d/motd.sh
./motd.sh
cat /etc/motd

#!/bin/sh

echo "Changing the SSH port to 4222"
echo "Disabling root password login"
echo "Enabling strict modes"
echo "Limiting authentication attempts to 4"
echo "Limiting number of sessions to 10"
echo "Enabling public key authentication"
echo "Disabling password authentication"
echo "Disabling rhosts"

cat > /etc/ssh/sshd_config << EOD
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Port 4222

SyslogFacility AUTH
LogLevel INFO

PermitRootLogin prohibit-password
StrictModes yes
MaxAuthTries 4
MaxSessions 10

PubkeyAuthentication yes

AuthorizedKeysFile      .ssh/authorized_keys

IgnoreRhosts yes

PasswordAuthentication no

# override default of no subsystems
Subsystem      sftp    /usr/lib/ssh/sftp-server

AllowTcpForwarding yes

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server


EOD

## Add the motd script to run on SSH login
#echo "Updating /etc/profile.d/motd.sh"
#cat << EOD > /etc/profile.d/motd.sh
##!/bin/sh
#/path/to/motd_script.sh
#EOD

chmod +x /etc/profile.d/motd.sh

echo "SSH policy has been updated"

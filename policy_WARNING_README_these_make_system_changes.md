# policy scripts 

these are run inside the alpine qcow image to perform initial setup.

Be careful not to run these on you host machine unless that's what you want.

## policy_firewall.sh
This installs awall and iptables and enables a cloud-server.json config

## policy_ssh
This updats your sshd_config to use port 4222 and some other stuff.

## policy_motd 
This  adds a script to you etc/profile.d that runs on login to update and print the motd

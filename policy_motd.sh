#!/bin/sh

echo '[MOTD Policy] Writing new motd script to /etc/profile.d'

echo '#!/bin/sh' > /etc/profile.d/motd.sh ;
echo 'lastlogins=$(last)' >> /etc/profile.d/motd.sh ;
#echo 'load=$(uptime)' >> /etc/profile.d/motd.sh ;
echo 'uptime=$(uptime)' >> /etc/profile.d/motd.sh ;
echo 'mem=$(free -m)' >> /etc/profile.d/motd.sh ;
echo 'pkgs=$(apk list -Iv)' >> /etc/profile.d/motd.sh ;
echo 'procs=$(ps aux)' >> /etc/profile.d/motd.sh ;
echo 'sshprocs=$(ps aux| grep sshd)' >> /etc/profile.d/motd.sh ;

echo 'date=$(date)' >> /etc/profile.d/motd.sh ;
echo 'security=$(netstat)' >> /etc/profile.d/motd.sh ;
echo 'netstat=$(netstat -plntu)' >> /etc/profile.d/motd.sh ;
#echo 'cpu_load=$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6)' >> /etc/profile.d/motd.sh ;
echo 'num_processes=$(ps -e | wc -l)' >> /etc/profile.d/motd.sh ;
echo 'cat > /etc/motd << EOD' >> /etc/profile.d/motd.sh ;

echo 'Installed Packages:' >> /etc/profile.d/motd.sh ;
echo '$pkgs' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
#echo 'Critical Security Updates:' >> /etc/profile.d/motd.sh ;
#echo '$security' >> /etc/profile.d/motd.sh ;
#echo '' >> /etc/profile.d/motd.sh ;
echo 'Current Running Processes:' >> /etc/profile.d/motd.sh ;
echo '$procs' >> /etc/profile.d/motd.sh ;

echo 'Welcome to HAPI Alpine host! Above are running processes and installed software' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'Last 4 Logins:' >> /etc/profile.d/motd.sh ;
echo '$lastlogins' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'System Load and Disk Usage:' >> /etc/profile.d/motd.sh ;
#echo '$load' >> /etc/profile.d/motd.sh ;
#echo '' >> /etc/profile.d/motd.sh ;
echo 'System Uptime:' >> /etc/profile.d/motd.sh ;
echo '$uptime' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'Memory Usage:' >> /etc/profile.d/motd.sh ;
echo '$mem' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'Active Netstats:' >> /etc/profile.d/motd.sh ;
echo '$security' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'Listening Ports:' >> /etc/profile.d/motd.sh ;
echo '$netstat' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
#echo 'CPU Load:' >> /etc/profile.d/motd.sh ;
#echo '$cpu_load' >> /etc/profile.d/motd.sh ;
#echo '' >> /etc/profile.d/motd.sh ;
echo 'Number of Running Processes:' >> /etc/profile.d/motd.sh ;
echo '$num_processes' >> /etc/profile.d/motd.sh ;
echo '' >> /etc/profile.d/motd.sh ;
echo 'Information updated on:$date' >> /etc/profile.d/motd.sh ;
echo 'EOD' >> /etc/profile.d/motd.sh ;
echo 'cat /etc/motd' >> /etc/profile.d/motd.sh ;
echo 'echo "latest info just added"' >> /etc/profile.d/motd.sh ;

echo '[MOTD Policy] making executable'

chmod +x /etc/profile.d/motd.sh ;

echo '[MOTD Policy] running once then printing.'
./motd.sh ;
## cat /etc/motd ; this should be done in the script now. maybe disable ssh motd. so no dups

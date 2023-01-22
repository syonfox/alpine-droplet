#!/usr/bin/env sh

echo '[Firewall Policy] installing awal ad iptables'
apk update && apk upgrade
## Install both IPv4 and IPv6 version of IPtables ##
apk add iptables iptables-doc
#ip6tables
## Install awall ##
apk add -u awall
## Verify it ##
apk version awall
# apk add ip6tables
#apk add iptables
#apk add -u awall
modprobe -v ip_tables   # IPv4
#modprobe -v ip6_tables  # if IPv6 is used
modprobe -v iptable_nat # if NAT is used aka router
rc-update add iptables
#rc-update add ip6tables

echo '[Firewall Policy Notes] alpine wall is alpine firewall https://wiki.alpinelinux.org/wiki/Alpine_Wall The best docs I have found are https://github.com/alpinelinux/awall'
echo '[Firewall Policy Notes] We are installing the policy /etc/awall/optional/cloud-server.json which when built creates iptables rules'
echo '[Firewall Policy Notes] Note we are not using ipv6 call me when we are at least v7 ;)'

#The Alpine Wall is a proposal for a new firewall management framework for the Alpine Linux operating system.
# The framework, called Alpine Wall (awall), is intended to address the limitations of the current firewall solution,
# . Awall will consist of three major components: data model, front-end, and back-end. It will also include a plugin
# architecture that allows for the extension of the data model and functionality to simplify common organization-specific
# tasks. The data model will describe the firewall configuration using concepts and terminology that are similar to those
# used in Shorewall. The back-end will translate the data in the model into configuration files that can be read by
# iptables-restore and ip6tables-restore. The front-end will be an ACF module that allows for the editing of the data
# model and the activation of changes using the back-end. The basic data model for awall includes concepts such as zones,
# services, forwarding policies, filtering rules, and NAT rules. The implementation of awall will need to consider issues
# such as performance, security, and ease of use.
#    Zones: A zone is a logical group of interfaces and subnets that can be used to define the source and destination of a network packet. Zones are defined by the interfaces and subnets that they contain.
#
#    Services: A service is a protocol and port combination that is used to identify the type of traffic that is being transmitted. Services are defined by the protocol and port number that they use.
#
#    Forwarding policy: A forwarding policy is used to define how packets are handled as they pass through the firewall. A forwarding policy consists of a source zone, a destination zone, and an action (such as accept, reject, or drop).
#
#    Filtering rule: A filtering rule is used to define how packets are filtered by the firewall based on the source and destination zones and the service that the packet is using. Filtering rules can also include optional connection and flow limits.
#
#    NAT rule: A NAT rule is used to define how packets are translated by the firewall as they pass through. NAT rules consist of a type (such as source NAT or destination NAT), source and destination zones, a service, and an IP and port range for the translation.
#
# To use awall, you will need to define your zones, services, and rules in the data model, and then use the front-end to edit and activate the changes. The back-end will then translate the data in the model into configuration files that can be read by iptables-restore and ip6tables-restore. You can also use plug-ins to extend the data model and functionality of awall to suit your specific needs.
echo "[Firewall Policy] Writing awall cloud-server"
echo "[Firewall Policy]                               (myssh, http, https) -(or tarpit)-> [pub zone] <-(or reject)- (dns, http, https, ssh, myssh, wg, ntp, ping)"
echo "[Firewall Policy] (http, https, ssh, myssh, wg, ntp, ping ,rsyncd, pg) -(or drop)-> [vpc zone] <-(or reject)- (dns, http, https, ssh, myssh, wg, ntp, ping ,rsyncd, pg)"
echo "[Firewall Policy]                                                            (accept) -> [wg  zone] <- (accept)"

cat > /etc/awall/optional/cloud-server.json << EOF
{
  "description": "Default awall policy to protect Cloud server",
  "zone": {
    "pub_zone": {
      "iface": "eth0"
    },
    "vpc_zone": {
      "iface": "eth1"
    },
    "wg_zone": {
      "iface": "wg0"
    }
  },
  "service": {
    "ssh": {
      "proto": "tcp",
      "port": 22
    },
    "myssh": {
      "proto": "tcp",
      "port": 4222
    },
    "http": {
      "proto": "tcp",
      "port": 80
    },
    "https": {
      "proto": "tcp",
      "port": 443
    },
    "https": {
      "proto": "tcp",
      "port": 443
    },
    "wg": {
      "proto": "udp",
      "port": 51194
    },
    "rsyncd": {
      "proto": "tcp",
      "port": 873
    },
    "pg": {
      "proto": "tcp",
      "port": 5432
    },
    "dns": {
      "proto": "udp",
      "port": 53
    },
    "ntp": {
      "proto": "udp",
      "port": 123
    }
  },


  "policy": [
    {
      "in": "pub_zone",
      "out": "_fw",
      "action": "tarpit"
    },
    {
      "in": "_fw",
      "out": "pub_zone",
      "action": "reject"
    },


    {
      "in": "vpc_zone",
      "out": "_fw",
      "action": "drop"
    },
    {
      "in": "_fw",
      "out": "vpc_zone",
      "action": "reject"
    },


    {
      "in": "wg_zone",
      "out": "_fw",
      "action": "accept"
    },
    {
      "in": "_fw",
      "out": "wg_zone",
      "action": "accept"
    }
  ],


  "filter": [
    {
      "in": "pub_zone",
      "service": "ping",
      "action": "accept",
      "flow-limit": {
        "count": 10,
        "interval": 6
      }
    },
      {
      "in": "pub_zone",
      "out": "_fw",
      "service": [ "http",  "https",  "myssh"],
      "action": "accept"
    },
    {
      "in": "_fw",
      "out": "pub_zone",
      "service": [ "dns",  "http",  "https",  "ssh",  "myssh",  "wg",  "ntp",  "ping"],
      "action": "accept"
    },



    {
      "in": "vpc_zone",
      "out": "_fw",
      "service": ["http",  "https",  "ssh",  "myssh",  "rsyncd", "pg",  "wg",  "ntp",  "ping"],
      "action": "accept"
    },
    {
      "in": "_fw",
      "out": "vpc_zone",
      "service": [ "dns",  "http",  "https",  "ssh",  "myssh",  "rsyncd", "pg",  "wg",  "ntp",  "ping"],
      "action": "accept"
    }
  ],


  "snat": [
    {
      "out": "pub_zone"
    }
  ],
  "clamp-mss": [
    {
      "out": "pub_zone"
    }
  ]
}

EOF

echo "[Firewall Policy] building awall cloud-server config"
awall list ; # se avvalible policies
awall enable cloud-server ; # duhh
awall translate -V ; # test
awall activate -f ; # must run after ANY change
#awall translate -V

echo "[Firewall Policy] saving iptables"
/etc/init.d/iptables save ; # actualy enable the generated iptables rules


echo '[Firewall Policy] Done installing awall firewall policy! woo make sure you install the ssh policy to as we block port 22!'

#  /etc/init.d/ip6tables save
#todo enable logging probably do this at the kernel level tho
#https://github.com/alpinelinux/awall/blob/master/test/mandatory/log.json
#https://wiki.alpinelinux.org/wiki/Configure_Networking
#iproute2
#
#You may wish to install the 'iproute2' package (note that this will also install iptables if not yet installed)
#
#apk add iprouteouti
#y\
#This provides the 'ss' command which is IMHO a 'better' version of netstat.
#
#Show listening tcp ports:
#
#ss -tl
#
#Show listening tcp ports and associated processes:
#
#ss -ptl
#
#Show listening and established tcp connections:
#
#ss -ta
#
#Show socket usage summary:
#
#ss -s
#
#Show more options:
#
#ss -h



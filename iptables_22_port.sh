edgeIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep "^10\." | head -n 1 )
#publicIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
publicIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep "^192\.168" | head -n 1 )
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F
iptables -F -t nat
iptables -I INPUT -p tcp --dport 9919 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9920 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9921 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9922 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9923 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9924 -j ACCEPT   
iptables -I INPUT -p tcp --dport 9925 -j ACCEPT   
#iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport 8888 -j DNAT --to-destination 10.10.10.1:8888
iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9925 -j DNAT --to-destination 10.10.10.25:22
#iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 8888 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.25 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9924 -j DNAT --to-destination 10.10.10.24:22
iptables -t nat -A POSTROUTING -d 10.10.10.24 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9923 -j DNAT --to-destination 10.10.10.23:22
iptables -t nat -A POSTROUTING -d 10.10.10.23 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9922 -j DNAT --to-destination 10.10.10.22:22
iptables -t nat -A POSTROUTING -d 10.10.10.22 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9921 -j DNAT --to-destination 10.10.10.21:22
iptables -t nat -A POSTROUTING -d 10.10.10.21 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9920 -j DNAT --to-destination 10.10.10.20:22
iptables -t nat -A POSTROUTING -d 10.10.10.20 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport 9919 -j DNAT --to-destination 10.10.10.19:22
iptables -t nat -A POSTROUTING -d 10.10.10.19 -p tcp --dport 22 -j SNAT --to-source ${edgeIP}

iptables-save > /etc/iptables.rules
iptables-restore < /etc/iptables.rules
#service iptables save
#service iptables restart
iptables -t nat -nL
#iptables -t nat -L -vn

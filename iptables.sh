edgeIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep "^10\." | head -n 1 )
publicIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F
iptables -F -t nat
iptables -I INPUT -p udp --dport 4500 -j ACCEPT   
iptables -I INPUT -p tcp --dport 4500 -j ACCEPT   
iptables -I INPUT -p udp --dport 1701 -j ACCEPT   
iptables -I INPUT -p tcp --dport 1701 -j ACCEPT   
iptables -I INPUT -p udp --dport 500 -j ACCEPT   
iptables -I INPUT -p tcp --dport 500 -j ACCEPT   
iptables -I INPUT -p tcp --dport 8888 -j ACCEPT   
#iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport  8888 -j DNAT --to-destination 10.10.10.1:8888
iptables -t nat -A PREROUTING -d 172.17.0.10 -p udp --dport 4500 -j DNAT --to-destination 10.10.10.1:4500
iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport 4500 -j DNAT --to-destination 10.10.10.1:4500
iptables -t nat -A PREROUTING -d 172.17.0.10 -p udp --dport 1701 -j DNAT --to-destination 10.10.10.1:1701
iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport 1701 -j DNAT --to-destination 10.10.10.1:1701
iptables -t nat -A PREROUTING -d 172.17.0.10 -p udp --dport 500 -j DNAT --to-destination 10.10.10.1:500
iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport 500 -j DNAT --to-destination 10.10.10.1:500
iptables -t nat -A PREROUTING -d 172.17.0.10 -p tcp --dport 8888 -j DNAT --to-destination 10.10.10.1:8888
#iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 8888 -j SNAT --to-source  ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 8888 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p udp --dport 4500 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 4500 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p udp --dport 1701 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 1701 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p udp --dport 500 -j SNAT --to-source ${edgeIP}
iptables -t nat -A POSTROUTING -d 10.10.10.1 -p tcp --dport 500 -j SNAT --to-source ${edgeIP}
#iptables -t nat -I POSTROUTING -p udp --dport 4500 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p tcp --dport 4500 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p udp --dport 1701 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p tcp --dport 1701 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p udp --dport 500 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p tcp --dport 500 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p tcp --dport 8888 -j MASQUERADE
iptables-save > /etc/iptables.rules
iptables-restore < /etc/iptables.rules
#service iptables save
#service iptables restart
iptables -t nat -nL
#iptables -t nat -L -vn

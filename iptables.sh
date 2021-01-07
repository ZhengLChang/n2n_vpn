edgeIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep "^10\." | head -n 1 )
#publicIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
publicIP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep "^172\.17" | head -n 1 )
destEdgeIP=10.10.10.12
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F
iptables -F -t nat
open_port=(22 4500 1701 500 8888 9999)
nat_port=(4500 1701 500 8888 9999)
#nat_port=(9999)
for port in ${open_port[@]}
do
  echo "open port ${port}"
  iptables -I INPUT -p udp --dport ${port} -j ACCEPT   
  iptables -I INPUT -p tcp --dport ${port} -j ACCEPT   
done
for port in ${nat_port[@]}
do
  destPort=${port}
  echo "nat port ${destPort} => ${port}"
  iptables -t nat -A PREROUTING -d ${publicIP} -p udp --dport ${destPort} -j DNAT --to-destination ${destEdgeIP}:${port}
  iptables -t nat -A PREROUTING -d ${publicIP} -p tcp --dport ${destPort} -j DNAT --to-destination ${destEdgeIP}:${port}
  iptables -t nat -A POSTROUTING -d ${destEdgeIP} -p udp --dport ${port} -j SNAT --to-source ${edgeIP}
  iptables -t nat -A POSTROUTING -d ${destEdgeIP} -p tcp --dport ${port} -j SNAT --to-source ${edgeIP}
done
iptables-save > /etc/iptables.rules
iptables-restore < /etc/iptables.rules
#service iptables save
#service iptables restart
iptables -t nat -nL
#iptables -t nat -L -vn
echo "publicIp ${publicIP}"
echo "edgeIP ${edgeIP}"
echo "destEdgeIP ${destEdgeIP}"

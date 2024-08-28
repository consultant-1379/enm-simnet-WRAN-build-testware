LOCAL_IP_ADDRESS=`host $HOSTNAME | awk '{print $4}'`
echo "LOCAL_IP_ADDRESS:$LOCAL_IP_ADDRESS  $1:1 $2:2 $3:3 $4:4 $HOSTNAME:HOSTNAME" > ran.txt
ifconfig -a | grep -i "inet " | awk '{print $2}' | awk -F: '{print $2}' | sort -ut. -k1,1 -k2,2n -k3,3n -k4,4n | grep -v "127.0.0.1" | grep -v "^$LOCAL_IP_ADDRESS$" > avail_IpAddr_IPv4.txt

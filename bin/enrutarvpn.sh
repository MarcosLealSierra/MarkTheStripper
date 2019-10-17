vpndev=tun0
internallandev=wlp2s0

echo "1" | sudo tee /proc/sys/net/ipv4/ip_forward

sudo iptables -t nat -A POSTROUTING -o $vpndev -j MASQUERADE
sudo iptables -A FORWARD -o $vpndev -i $internallandev -m conntrack --ctstate NEW -j ACCEPT

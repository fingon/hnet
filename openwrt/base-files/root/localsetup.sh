NETWORK=/etc/config/network
if [ -f ${NETWORK}.new ]
then
    echo " * Replacing network configuration $NETWORK"
    mv ${NETWORK}.new ${NETWORK}
fi

# Disable unneeded services
echo " * Disabling services"
for SERVICE in \
  babeld \
  bird4 \
  cron \
  dhclient \
  dhclient6 \
  dhcpd \
  dhcpd6 \
  dibbler-client \
  dibbler-server \
  dnsmasq \
  radvd \
  telnet 
do
    if [ -f /etc/init.d/$SERVICE ]
    then
        echo "  - disabling $SERVICE"
        /etc/init.d/$SERVICE disable
    fi
done  

# Disable firewalling altogether
# (Room for future development, sigh)
/etc/init.d/firewall disable

HOSTNAME=inner
echo " * Setting hostname to $HOSTNAME"
uci set "system.@system[0].hostname=$HOSTNAME"
uci commit system

# Ensure that the rc.local is _really_ executed last..
#mv /etc/rc.d/S95done /etc/rc.d/S99zdone

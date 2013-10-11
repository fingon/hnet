NETWORK=/etc/config/network
if [ -f ${NETWORK}.new ]
then
    echo " * Replacing network configuration $NETWORK"
    mv ${NETWORK}.new ${NETWORK}
fi

# Disable dnsmasq - it's not provisioned correctly and effectively
# lies in our setup
/etc/init.d/dnsmasq disable

# XXX - shouldn't this be enabled by default?
#/etc/init.d/hnet enable

HOSTNAME=inner
echo " * Setting hostname to $HOSTNAME"
uci set "system.@system[0].hostname=$HOSTNAME"
uci commit system

# Ensure that the rc.local is _really_ executed last..
#mv /etc/rc.d/S95done /etc/rc.d/S99zdone

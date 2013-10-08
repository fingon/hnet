NETWORK=/etc/config/network
if [ -f ${NETWORK}.new ]
then
    echo " * Replacing network configuration $NETWORK"
    mv ${NETWORK}.new ${NETWORK}
fi

HOSTNAME=inner
echo " * Setting hostname to $HOSTNAME"
uci set "system.@system[0].hostname=$HOSTNAME"
uci commit system

# Ensure that the rc.local is _really_ executed last..
#mv /etc/rc.d/S95done /etc/rc.d/S99zdone

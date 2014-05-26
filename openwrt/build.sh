#!/bin/bash -ue
#-*-sh-*-
#
# $Id: build.sh $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 20:11:27 2013 mstenber
# Last modified: Fri May 23 16:07:11 2014 mstenber
# Edit time:     49 min
#

# V2
#HNET_PACKAGES="hnet"
# V3
HNET_PACKAGES="hnet hnet-full"
#GPLUS_PACKAGES="python lsqlite3 openvpn-devel-openssl openvpn-easy-rsa google-api-python-client"
GPLUS_PACKAGES=""
EXTRA_PACKAGES="netkit luci rsync strace tcpdump procps valgrind lsof"

INSTALLED_FILE=".installed"

PACKAGES="$HNET_PACKAGES $GPLUS_PACKAGES $EXTRA_PACKAGES"

install_packages () {
    for PACKAGE in $*
    do
        echo "Installing package $PACKAGE"
        (cd dist && scripts/feeds install $PACKAGE)
    done
}

# Update feeds.conf, update list of available feeds, and install hnet+netkit
# packages explicitly

if [ -f $INSTALLED_FILE ]
then
    GOT=`cat $INSTALLED_FILE`
    if [ ! "$PACKAGES" = "$GOT" ]
    then
        echo "Installed mismatch - $PACKAGES / $GOT"
        rm -f $INSTALLED_FILE
    fi
fi

if [ ! -f $INSTALLED_FILE -o ! -f dist/feeds.conf ]
then
    if [ -L dist/.config ]
    then 
        # nop if symlink
        true
    elif [ -f dist/.config ]
    then
        echo "dist/.config is non-symlink! Something is horribly wrong (1)."
        exit 1
    fi
    egrep -v openwrt-routing < dist/feeds.conf.default > dist/feeds.conf
    echo "src-link hnet "`pwd`/feed >> dist/feeds.conf
    echo "src-link routing "`pwd`/routing >> dist/feeds.conf
    (cd dist && scripts/feeds update)

    # Get rid of existing packages; this way, we'll have consistent builds
    # ( and easier configuration maintenance ) 
    (cd dist && scripts/feeds uninstall -a)

    install_packages $PACKAGES

    # Store the current installed package list
    echo "$PACKAGES" > $INSTALLED_FILE

    # Get rid of .config file generated by helpful (and fairly stupid)
    # install..
    rm -f dist/.config
fi

# NOTE: This is important to do later - install-packages plays funny
# bugger with config files..

rm -f config
ln -s ${1}-config config

# Link our 'config' to dist/.config if necessary
if [ -L dist/.config ]
then 
    # nop if symlink already (we hope it points in the right place)
    true
elif [ -f dist/.config ]
then
    echo "dist/.config is non-symlink! Something is horribly wrong (2)."
    exit 1
else
    ln -s ../config dist/.config
fi


make -C dist -j 9

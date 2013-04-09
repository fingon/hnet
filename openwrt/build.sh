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
# Last modified: Tue Apr  9 16:10:02 2013 mstenber
# Edit time:     18 min
#

HNET_PACKAGES="hnet netkit"
EXTRA_PACKAGES="luci rsync strace tcpdump"

install_packages () {
    for PACKAGE in $*
    do
        echo "Installing package $PACKAGE"
        (cd dist && scripts/feeds install $PACKAGE)
    done
}

# Link files/ to dist/
if [ ! -L dist/files ]
then 
    ln -s ../files dist/ 
fi

# Update feeds.conf, update list of available feeds, and install hnet+netkit
# packages explicitly
if [ ! -f dist/feeds.conf ]
then
    if [ -f dist/.config ]
    then
        echo "dist/.config is non-symlink! Something is horribly wrong (1)."
        exit 1
    fi
    cp feeds.conf dist/
    echo "src-link hnet "`pwd`/feed >> dist/feeds.conf
    (cd dist && scripts/feeds update)
    install_packages $HNET_PACKAGES
    install_packages $EXTRA_PACKAGES

    # Get rid of .config file generated by helpful (and fairly stupid)
    # install..
    rm -f dist/.config
fi

# NOTE: This is important to do later - install-packages plays funny
# bugger with config files..

rm -f config
ln -s ${1}-config config

# Link our 'config' to dist/.config if necessary
if [ -f dist/.config ]
then
    echo "dist/.config is non-symlink! Something is horribly wrong (2)."
    exit 1
elif [ ! -L dist/.config ]
then 
    ln -s ../config dist/.config
fi


make -C dist -j 9

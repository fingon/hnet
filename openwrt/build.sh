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
# Last modified: Mon Apr  8 20:17:34 2013 mstenber
# Edit time:     5 min
#

# Link our 'config' to dist/.config if necessary
if [ ! -L dist/.config ]
then 
    ln -s ../config dist/.config
fi

# Link files/ to dist/
if [ ! -L dist/files ]
then 
    ln -s ../files dist/ 
fi

rm -f config
ln -s ${1}-config config

# Update feeds.conf, update list of available feeds, and install hnet+netkit
# packages explicitly
if [ ! -f dist/feeds.conf ]
then
    cp feeds.conf dist/
    echo "src-link hnet "`pwd`/feed >> dist/feeds.conf
    (cd dist \
        && scripts/feeds update \
        && scripts/feeds install hnet \
        && scripts/feeds install netkit \
        )
fi

make -C dist -j 9

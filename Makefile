#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 14:12:02 2013 mstenber
# Last modified: Tue Apr  9 13:25:41 2013 mstenber
# Edit time:     15 min
#

all: build

build: netkit.build openwrt.build

clean: netkit.clean openwrt.clean

openwrt.build:
	make -C openwrt build

openwrt.clean:
	make -C openwrt clean

netkit.build:
	make -C netkit build

netkit.clean:
	make -C netkit/fs clean
	make -C netkit/kernel clean

# Git utility targets

init:
	git submodule init --recursive
	git submodule update --recursive

sync:
	git submodule sync
	git submodule foreach git submodule sync


# Probably highly self-only tool, to make _all_ nested submodules rw
# instead of the default ro url
rw: sync rewrite-git-urls-rw

rewrite-git-urls-rw:
	perl -i.bak -pe \
		's/git:\/\/github\.com\/fingon/git\@github\.com:fingon/g' \
		`find .git -name 'config' -print`

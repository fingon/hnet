#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 14:12:02 2013 mstenber
# Last modified: Tue Apr  9 16:25:51 2013 mstenber
# Edit time:     29 min
#

all: build

## Meta-targets available

# Build netkit + openwrt for UML + test infra labs for it

build: netkit.build openwrt.build ttin.build

# 'fast' clean

clean: openwrt.clean ttin.clean

# ~distro-only level clean (should clean all binaries etc)

dirclean: clean netkit.clean openwrt.dirclean

# Subdir-specific rules for build/clean/dirclean

openwrt.build:
	make -C openwrt build

openwrt.clean:
	make -C openwrt clean

openwrt.dirclean:
	make -C openwrt dirclean

netkit.build:
	make -C netkit build

netkit.clean:
	make -C netkit/fs clean
	make -C netkit/kernel clean

ttin.build:
	make -C ttin build

ttin.clean:
	make -C ttin clean

# Git utility targets
init:
	git submodule update --init --recursive

sync:
	git submodule sync
	git submodule foreach --recursive git submodule sync

# Probably highly self-only tool, to make _all_ nested submodules rw
# instead of the default ro url
rw: sync rewrite-git-urls-rw
	git submodule foreach --recursive git checkout master
	(cd component/odhcp6c && git checkout hnet)
	(cd component/luasocket && git checkout unstable)

rewrite-git-urls-rw:
	perl -i.bak -pe \
		's/git:\/\/github\.com\/fingon/git\@github\.com:fingon/g' \
		`find .git -name 'config' -print`

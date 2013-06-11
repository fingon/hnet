#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 14:12:02 2013 mstenber
# Last modified: Tue Jun 11 14:17:19 2013 mstenber
# Edit time:     57 min
#

HNETDIR=$(CURDIR)
SUBDIRS=build component netkit openwrt ttin

# omit netkit - cleaning it is rather expensive
CLEANSUBDIRS=build component openwrt ttin

include $(HNETDIR)/recmake.mk

build.clean:
	rm -rf build

build.build:
	mkdir -p build/bin
	mkdir -p build/lib
	# Copy over libc so that we can use it in netkit..
	# Not very elegant, but oh well
	cp -a  /lib/x86_64-linux-gnu/libc[-.]* build/lib

# Funny demo stuff
demo.start:
	./demo_start.sh

demo.stop:
	./demo_stop.sh

# Git utility targets
init:
	git submodule init
	git submodule update --init --recursive

sync:
	git submodule sync
	git submodule foreach --recursive git submodule sync

pull:
	git submodule foreach --recursive git pull

PUSHCMD='(git status | grep -q ahead) && git push || true'

push:
	git submodule foreach --recursive $(PUSHCMD)
	@sh -c $(PUSHCMD)

# Setup cmd for ubuntu-1204 / Debian 7.0 (aka wheezy)
setup-debianish:
	sudo usermod -a -G disk `whoami`
	sudo apt-get update
	sudo apt-get --yes install `cat packages-debian-70 | egrep -v '^#'`

# Probably highly self-only tool, to make _all_ nested submodules rw
# instead of the default ro url
rw: sync rewrite-git-urls-rw
	git submodule foreach --recursive git checkout master
	(cd component/odhcp6c && git checkout hnet)
	(cd component/luasocket && git checkout unstable)
	(cd component/core && git checkout ms-dns)
	(cd openwrt/feed && git checkout ms-dns)
	(cd netkit/kernel && git checkout ms-stable)

update-owrt:
	python util/rewrite-feed-makefiles.py

uo: update-owrt

rewrite-git-urls-rw:
	perl -i.bak -pe \
		's/git:\/\/github\.com\/fingon/git\@github\.com:fingon/g' \
		`find .git -name 'config' -print`

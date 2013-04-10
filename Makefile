#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 14:12:02 2013 mstenber
# Last modified: Wed Apr 10 13:01:54 2013 mstenber
# Edit time:     35 min
#

HNETDIR=$(CURDIR)
SUBDIRS=component netkit openwrt ttin

# omit netkit - cleaning it is rather expensive
CLEANSUBDIRS=component openwrt ttin

include $(HNETDIR)/recmake.mk

clean: $(CLEANS)
	rm -rf build

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

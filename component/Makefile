#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Wed Apr 10 13:08:27 2013 mstenber
# Edit time:     17 min
#
#

# Build host-specific versions of the components, and store the
# relevant binaries under ../build. We don't build components we don't
# explicitly _care_ about, though.

HNETDIR?=$(CURDIR)/..
BUILDDIR=$(HNETDIR)/build
BINDIR=$(BUILDDIR)/bin

SUBDIRS=luasocket bird dnsmasq

include $(HNETDIR)/recmake.mk

luasocket.build:
	mkdir -p $(BINDIR)
	$(MAKE) -C luasocket prefix=$(BUILDDIR)
	$(MAKE) -C luasocket prefix=$(BUILDDIR) install

bird.build:
	if [ ! -f bird/Makefile ] ; then ( cd bird && autoconf && ./configure --with-lua-includes=/usr/include/lua5.1 --with-lua-suffix=5.1 --enable-ipv6 ) ; fi
	$(MAKE) -C bird
	(cd bird && mv bird birdc $(BINDIR))

dnsmasq.build:
	$(MAKE) -C dnsmasq
	mv dnsmasq/src/dnsmasq $(BINDIR)

odhcp6c.build:
	(cd odhcp6c && cmake . && $(MAKE))
	mv odhcp6c/odhcp6c $(BINDIR)

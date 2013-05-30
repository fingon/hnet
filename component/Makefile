#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Thu May 30 10:39:20 2013 mstenber
# Edit time:     33 min
#
#

# Build host-specific versions of the components, and store the
# relevant binaries under ../build. We don't build components we don't
# explicitly _care_ about, though.

HNETDIR?=$(CURDIR)/..
BUILDDIR=$(HNETDIR)/build
LUADIR=$(BUILDDIR)/share/lua/5.1
BINDIR=$(BUILDDIR)/bin

SUBDIRS=bird dnsmasq odhcp6c \
	luasocket lualfs luamd5 luavstruct

include $(HNETDIR)/recmake.mk

lualfs.build:
	$(MAKE) -C lualfs PREFIX=$(BUILDDIR) LUA_INC=/usr/include/lua5.1
	$(MAKE) -C lualfs PREFIX=$(BUILDDIR) LUA_INC=/usr/include/lua5.1 install

luamd5.build:
	$(MAKE) -C luamd5 PREFIX=$(BUILDDIR) LUA_INC=/usr/include/lua5.1
	$(MAKE) -C luamd5 PREFIX=$(BUILDDIR) LUA_INC=/usr/include/lua5.1 install
	$(MAKE) -C luamd5 PREFIX=$(BUILDDIR) LUA_INC=/usr/include/lua5.1 clean

luasocket.build:
	$(MAKE) -C luasocket prefix=$(BUILDDIR)
	$(MAKE) -C luasocket prefix=$(BUILDDIR) install

luavstruct.build:
	rm -rf $(LUADIR)/vstruct
	cp -a luavstruct/vstruct $(LUADIR)/vstruct

luavstruct.clean:
	rm -rf $(LUADIR)/vstruct

bird.build:
	if [ ! -f bird/configure ] ; then ( cd bird && autoconf ) ; fi
	if [ ! -f bird/build/ipv4/Makefile ] ; then ( mkdir -p bird/build/ipv4 && cd bird/build/ipv4 && ../../configure --enable-debug ) ; fi
	$(MAKE) -C bird/build/ipv4
	if [ ! -f bird/build/ipv6/Makefile ] ; then ( mkdir -p bird/build/ipv6 && cd bird/build/ipv6 && ../../configure --with-lua-includes=/usr/include/lua5.1 --with-lua-suffix=5.1 --enable-ipv6 --enable-debug ) ; fi
	$(MAKE) -C bird/build/ipv6
	#(cd bird/build/ipv4 && mv bird $(BINDIR)/bird4)
	#(cd bird/build/ipv4 && mv birdc $(BINDIR)/birdc4)
	(cd bird/build/ipv6 && mv bird birdc $(BINDIR))

bird.clean:
	rm -rf bird/build

dnsmasq.build:
	$(MAKE) -C dnsmasq
	mv dnsmasq/src/dnsmasq $(BINDIR)

odhcp6c.build:
	(cd odhcp6c && cmake . && $(MAKE))
	mv odhcp6c/odhcp6c $(BINDIR)
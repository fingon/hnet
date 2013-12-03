#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Tue Dec  3 06:49:01 2013 mstenber
# Edit time:     51 min
#
#

# Build host-specific versions of the components, and store the
# relevant binaries under ../build. We don't build components we don't
# explicitly _care_ about, though.

HNETDIR?=$(CURDIR)/..
BUILDDIR=$(HNETDIR)/build
LUADIR=$(BUILDDIR)/share/lua/5.1
BINDIR=$(BUILDDIR)/bin

BIRD_CONF=
BIRD_MAKE=

# this disables detach -> some of the existing infra breaks (notably
# in ttin/). *sigh* (it is needed if you need to debug C bird code,
# though.)
#BIRD_CONF=--enable-debug


SUBDIRS=bird dnsmasq odhcp6c \
	luasocket luamd5 luavstruct

FORKED_SUBDIRS=bird dnsmasq luasocket
#odhcp6c

include $(HNETDIR)/recmake.mk

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
	if [ ! -f bird/build/ipv4/Makefile ] ; then ( mkdir -p bird/build/ipv4 && cd bird/build/ipv4 && ../../configure $(BIRD_CONF) ) ; fi
	$(MAKE) -C bird/build/ipv4 $(BIRD_MAKE)
	if [ ! -f bird/build/ipv6/Makefile ] ; then ( mkdir -p bird/build/ipv6 && cd bird/build/ipv6 && ../../configure --with-lua-includes=/usr/include/lua5.1 --with-lua-suffix=5.1 --enable-ipv6 $(BIRD_CONF) ) ; fi
	$(MAKE) -C bird/build/ipv6 $(BIRD_MAKE)
	(cd bird/build/ipv4 && mv bird $(BINDIR)/bird4)
	(cd bird/build/ipv4 && mv birdc $(BINDIR)/birdc4)
	(cd bird/build/ipv6 && mv bird birdc $(BINDIR))

bird.clean:
	rm -f bird/configure
	rm -rf bird/build

dnsmasq.build:
	$(MAKE) -C dnsmasq
	mv dnsmasq/src/dnsmasq $(BINDIR)

odhcp6c.build:
	(cd odhcp6c && cmake -DEXT_PREFIX_CLASS=200 . && $(MAKE))
	mv odhcp6c/odhcp6c $(BINDIR)

add-upstream:
	(cd bird && git remote add up git://git.nic.cz/bird.git)
	(cd dnsmasq && git remote add up git://thekelleys.org.uk/dnsmasq.git)
	(cd luasocket && git remote add up git://github.com/diegonehab/luasocket.git)

#	(cd odhcp6c && git remote add up git://github.com/sbyx/odhcp6c.git)


%.fetch:
	(cd $* && git fetch up)

fetch: $(FORKED_SUBDIRS:%=%.fetch)


#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Thu Jan 16 18:01:59 2014 mstenber
# Edit time:     117 min
#
#

# Build host-specific versions of the components, and store the
# relevant binaries under ../build. We don't build components we don't
# explicitly _care_ about, though.

HNETDIR?=$(CURDIR)/..
BUILDDIR=$(HNETDIR)/build
LUADIR=$(BUILDDIR)/share/lua/5.1
BINDIR=$(BUILDDIR)/bin
LIBDIR=$(BUILDDIR)/lib
INCLUDEDIR=$(BUILDDIR)/include

BIRD_CONF=
BIRD_MAKE=

CMAKE_DEFS=\
  -DCMAKE_INSTALL_PREFIX:PATH=$(BUILDDIR) \
  -DCMAKE_C_FLAGS=-I$(INCLUDEDIR) \
  -DCMAKE_SHARED_LINKER_FLAGS=-L$(LIBDIR) \
  -DCMAKE_EXE_LINKER_FLAGS="-L$(LIBDIR)"


# this disables detach -> some of the existing infra breaks (notably
# in ttin/). *sigh* (it is needed if you need to debug C bird code,
# though.)
#BIRD_CONF=--enable-debug


SUBDIRS=bird dnsmasq odhcp6c \
	luasocket luamd5 luavstruct \
	json-c libubox ubus hnetd ohybridproxy

FORKED_SUBDIRS=bird dnsmasq luasocket
#odhcp6c

include $(HNETDIR)/recmake.mk

%.clean:
	(cd $* && git clean -dfx .)

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

bird.build:
	if [ ! -f bird/configure ] ; then ( cd bird && autoconf ) ; fi
	if [ ! -f bird/build/ipv4/Makefile ] ; then ( mkdir -p bird/build/ipv4 && cd bird/build/ipv4 && ../../configure $(BIRD_CONF) ) ; fi
	$(MAKE) -C bird/build/ipv4 $(BIRD_MAKE)
	if [ ! -f bird/build/ipv6/Makefile ] ; then ( mkdir -p bird/build/ipv6 && cd bird/build/ipv6 && ../../configure --with-lua-includes=/usr/include/lua5.1 --with-lua-suffix=5.1 --enable-ipv6 $(BIRD_CONF) ) ; fi
	$(MAKE) -C bird/build/ipv6 $(BIRD_MAKE)
	(cd bird/build/ipv4 && mv bird $(BINDIR)/bird4)
	(cd bird/build/ipv4 && mv birdc $(BINDIR)/birdc4)
	(cd bird/build/ipv6 && mv bird birdc $(BINDIR))

dnsmasq.build:
	$(MAKE) -C dnsmasq
	mv dnsmasq/src/dnsmasq $(BINDIR)

odhcp6c.build:
	(cd odhcp6c && cmake -DEXT_PREFIX_CLASS=200 . && $(MAKE))
	mv odhcp6c/odhcp6c $(BINDIR)

json-c.build:
	if [ ! -f json-c/configure ] ; then (cd json-c && ./autogen.sh ) ; fi
	if [ ! -f json-c/Makefile ] ; then (cd json-c && ./configure --prefix=$(BUILDDIR)) ; fi
	rm -rf $(INCLUDEDIR)/json
	(cd json-c && make install)

libubox.build:
	(cd libubox && PKG_CONFIG_PATH=$(BUILDDIR)/lib/pkgconfig cmake $(CMAKE_DEFS). && $(MAKE) install)

ubus.build:
	(cd ubus && cmake $(CMAKE_DEFS) -DBUILD_LUA=OFF . && $(MAKE) install)

hnetd.build:
	(cd hnetd && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

ohybridproxy.build:
	(cd ohybridproxy && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

babels.build:
	$(MAKE) -C babels install PREFIX=$(BUILDDIR)

add-upstream:
	(cd bird && git remote add up git://git.nic.cz/bird.git)
	(cd dnsmasq && git remote add up git://thekelleys.org.uk/dnsmasq.git)
	(cd luasocket && git remote add up git://github.com/diegonehab/luasocket.git)

#	(cd odhcp6c && git remote add up git://github.com/sbyx/odhcp6c.git)


%.fetch:
	(cd $* && git fetch up)

fetch: $(FORKED_SUBDIRS:%=%.fetch)


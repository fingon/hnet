#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Tue Mar 18 15:38:50 2014 mstenber
# Edit time:     155 min
#
#

# Build host-specific versions of the components, and store the
# relevant binaries under ../build. We don't build components we don't
# explicitly _care_ about, though.

HNETDIR?=$(CURDIR)/..
BUILDDIR=$(HNETDIR)/build
BINDIR=$(BUILDDIR)/bin
LIBDIR=$(BUILDDIR)/lib
INCLUDEDIR=$(BUILDDIR)/include

CMAKE_DEFS=\
  -DCMAKE_INSTALL_PREFIX:PATH=$(BUILDDIR) \
  -DCMAKE_C_FLAGS=-I$(INCLUDEDIR) \
  -DCMAKE_SHARED_LINKER_FLAGS=-L$(LIBDIR) \
  -DCMAKE_EXE_LINKER_FLAGS="-L$(LIBDIR)" \
  -DBUILD_LUA=OFF \
  -DENABLE_SYSTEMD=OFF

SUBDIRS=babels dnsmasq odhcp6c \
	json-c libubox ubus uci \
	odhcpd hnetd \
	mDNSResponder ohybridproxy

include $(HNETDIR)/recmake.mk

%.clean:
	(cd $* && git clean -dfx .)

dnsmasq.build:
	$(MAKE) -C dnsmasq
	mkdir -p $(BINDIR)
	mv dnsmasq/src/dnsmasq $(BINDIR)

odhcp6c.build:
	(cd odhcp6c && cmake -DEXT_PREFIX_CLASS=200 . && $(MAKE))
	mkdir -p $(BINDIR)
	mv odhcp6c/odhcp6c $(BINDIR)

json-c.build:
	if [ ! -f json-c/configure ] ; then (cd json-c && ./autogen.sh ) ; fi
	if [ ! -f json-c/Makefile ] ; then (cd json-c && ./configure --prefix=$(BUILDDIR)) ; fi
	rm -rf $(INCLUDEDIR)/json
	(cd json-c && $(MAKE) install)
	[ ! -L $(INCLUDEDIR)/json ] && ln -s json-c $(INCLUDEDIR)/json

libubox.build: json-c.build
	(cd libubox && PKG_CONFIG_PATH=$(BUILDDIR)/lib/pkgconfig cmake $(CMAKE_DEFS) . && $(MAKE) install)

ubus.build: libubox.build
	(cd ubus && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

uci.build: ubus.build
	(cd uci && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

odhcpd.build: uci.build
	(cd odhcpd && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

hnetd.build: uci.build
	(cd hnetd && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

ohybridproxy.build: uci.build mDNSResponder.build
	(cd ohybridproxy && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

babels.build:
	$(MAKE) -C babels install PREFIX=$(BUILDDIR)


# default 'install' target tries to run all over /etc; so just use InstallX
# subtargets

# -j N doesn't seem to work too well here - so calling make by hand.

# InstalledDaemon seems problematic - we _want_ mdnsd, but it also
# plays with /etc..
mDNSResponder.build:
	INSTBASE=$(BUILDDIR) make -C mDNSResponder/mDNSPosix os=linux all
	INSTBASE=$(BUILDDIR) make -C mDNSResponder/mDNSPosix os=linux InstalledLib InstalledClients
	mkdir -p $(BUILDDIR)/sbin
	cp mDNSResponder/mDNSPosix/build/prod/mdnsd $(BUILDDIR)/sbin

check: hnetd.build
	LD_LIBRARY_PATH=$(LIBDIR) make -C hnetd check

#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:23:54 2013 mstenber
# Last modified: Thu Jul 17 11:09:10 2014 mstenber
# Edit time:     183 min
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
	json-c libubox uci \
	odhcpd hnetd \
	mDNSResponder ohybridproxy \
	minimalist-pcproxy

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
	if [ ! -f json-c/configure -o ! -f json-c/Makefile ] ; then (cd json-c && rm -f aclocal.m4 config.h.in configure && ./autogen.sh ) ; fi
	if [ ! -f json-c/Makefile ] ; then (cd json-c && ./configure --prefix=$(BUILDDIR) --disable-dependency-tracking ) ; fi
	rm -rf $(INCLUDEDIR)/json
	$(MAKE) -j1 -C json-c
	$(MAKE) -C json-c install
	[ ! -L $(INCLUDEDIR)/json ] && ln -s json-c $(INCLUDEDIR)/json || true

libubox.build: json-c.build
	(cd libubox && PKG_CONFIG_PATH=$(BUILDDIR)/lib/pkgconfig cmake $(CMAKE_DEFS) . && $(MAKE) install)

uci.build: libubox.build
	(cd uci && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

odhcpd.build: uci.build
	(cd odhcpd && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

hnetd.build: uci.build
	(cd hnetd && cmake $(CMAKE_DEFS) -DL_LEVEL=7 . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

ohybridproxy.build: uci.build mDNSResponder.build
	(cd ohybridproxy && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

minimalist-pcproxy.build: uci.build mDNSResponder.build
	(cd minimalist-pcproxy && cmake $(CMAKE_DEFS) . && LD_LIBRARY_PATH=$(LIBDIR) $(MAKE) install)

babels.build:
	if [ ! -f babels/version.h ] ; then echo '#define BABEL_VERSION "hnet"' > babels/version.h ; fi
	$(MAKE) -C babels install PREFIX=$(BUILDDIR)


# default 'install' target tries to run all over /etc; so just use InstallX
# subtargets

# -j N doesn't seem to work too well here - so calling make by hand.

# InstalledDaemon seems problematic - we _want_ mdnsd, but it also
# plays with /etc..
mDNSResponder.build:
	INSTBASE=$(BUILDDIR) make -C mDNSResponder/mDNSPosix os=linux all
	mkdir -p $(BUILDDIR)/bin
	mkdir -p $(BUILDDIR)/include
	mkdir -p $(BUILDDIR)/lib
	mkdir -p $(BUILDDIR)/sbin
	INSTBASE=$(BUILDDIR) make -C mDNSResponder/mDNSPosix os=linux InstalledLib InstalledClients
	cp mDNSResponder/mDNSPosix/build/prod/mdnsd $(BUILDDIR)/sbin

check: hnetd.build
	LD_LIBRARY_PATH=$(LIBDIR) make -C hnetd check

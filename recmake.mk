#
# $Id: recmake.mk $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 12:42:57 2013 mstenber
# Last modified: Wed Apr 10 13:05:39 2013 mstenber
# Edit time:     11 min
#
#

# This is a set of make rules for consolidated, subdirectory-aware
# build process.

# Assumptions: Before including this, SUBDIRS is set (if applicable).

# As a result, subdir-specific {command}.{target} rules are referred
# from {command} target.

all: build

BUILDSUBDIRS?=$(SUBDIRS)
CLEANSUBDIRS?=$(SUBDIRS)
DIRCLEANSUBDIRS?=$(SUBDIRS)

BUILDS?=$(BUILDSUBDIRS:%=%.build)
CLEANS?=$(CLEANSUBDIRS:%=%.clean)
DIRCLEANS?=$(DIRCLEANSUBDIRS:%=%.dirclean)

build: $(BUILDS)

%.build:
	$(MAKE) -C $* build

clean: $(CLEANS)


%.clean:
	$(MAKE) -C $* clean

dirclean: $(DIRCLEANS)

%.dirclean:
	$(MAKE) -C $* dirclean

.PHONY: all build clean dirclean

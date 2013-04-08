#
# $Id: Makefile $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Apr  8 19:57:22 2013 mstenber
# Last modified: Mon Apr  8 20:15:07 2013 mstenber
# Edit time:     11 min
#

# This is wrapper around real OpenWRT distro (under dist/)
# and the OpenWRT-hnet convenience stuff stored here.

# Assumptions:
# - dist/.config symlink points to 'config' here
# - dist/files symlink points to 'files' subdirectory here

# - 'config' here points to desired hw-specific config
# e.g. uml-config

DEFAULT_BUILD_TARGET=uml

build:
	./build.sh $(DEFAULT_BUILD_TARGET)

myclean:
	@rm -f dist/feeds.conf
	@rm -f dist/files

# Two variants which also affect underlying OWRT..

clean: myclean
	@make -C dist clean

dirclean: myclean
	@make -C dist dirclean

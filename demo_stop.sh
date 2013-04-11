#!/bin/bash -ue
#-*-sh-*-
#
# $Id: demo_stop.sh $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Thu Apr 11 19:00:23 2013 mstenber
# Last modified: Thu Apr 11 19:05:42 2013 mstenber
# Edit time:     0 min
#

export NETKIT_HOME=`pwd`/netkit
export PATH=$NETKIT_HOME/bin:$PATH

vclean --clean-all

#!/bin/bash -ue
#-*-sh-*-
#
# $Id: demo_start.sh $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Thu Apr 11 18:59:43 2013 mstenber
# Last modified: Thu Apr 11 19:05:46 2013 mstenber
# Edit time:     1 min
#

export NETKIT_HOME=`pwd`/netkit
export PATH=$NETKIT_HOME/bin:$PATH

(cd ttin/lab/bird7 && lstart)

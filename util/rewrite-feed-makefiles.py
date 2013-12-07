#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Python -*-
#
# $Id: rewrite-feed-makefiles.py $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Wed Apr 10 16:33:42 2013 mstenber
# Last modified: Sat Dec  7 21:23:07 2013 mstenber
# Edit time:     17 min
#
"""

This is utility script, which should be run from hnet root.

What it does, is rewrites openwrt/feed/X/Makefile to point at latest
commit in component/Y

(X==Y sometimes, sometimes X is similar to Y)


"""

import os
import datetime

def shell_to_string(s):
    return os.popen(s).read().strip()

owrt2component = {
    # Version 2 (=Lua + Bird6 + netifd/Linux infra)
    'bird6-elsa': 'bird',
    'hnet': 'core',
    #'hnet-dnsmasq-dhcpv6': 'dnsmasq',
    #'hnet-odhcp6c': 'odhcp6c',
    #'hnet-luasocket': 'luasocket',
    #'lualfs': 'lualfs',
    'luamd5': 'luamd5',
    #'luavstruct': 'luavstruct'

    # Version 3 (=hnetd + babels(=hnet-babeld))
    'hnetd': 'hnetd',
    'hnet-babeld' : 'babels',

    }

for owname, cname in owrt2component.items():
    component_version = shell_to_string('(cd component/%(cname)s && git rev-parse HEAD)' % locals())
    assert component_version, 'unable to get component version for %s' % cname
    owmakefile = os.path.join('openwrt', 'feed', owname, 'Makefile')
    owrt_version = shell_to_string("egrep '^PKG_SOURCE_VERSION' '%(owmakefile)s' | cut -d '=' -f 2" % locals())
    assert owrt_version, 'unable to get openwrt version for %s' % cname
    if owrt_version != component_version:
        print 'Upgrading', cname, owrt_version, component_version
        cmd = "perl -i.bak -pe 's/^PKG_SOURCE_VERSION.*$/PKG_SOURCE_VERSION:=%(component_version)s/' '%(owmakefile)s'" % locals()
        #print cmd
        os.system(cmd)
        ts = datetime.datetime.now().strftime('%Y-%m-%d')
        cmd = "perl -i.bak -pe 's/^PKG_VERSION.*$/PKG_VERSION:=%(ts)s-\$(PKG_SOURCE_VERSION)/' '%(owmakefile)s'" % locals()
        #print cmd
        os.system(cmd)



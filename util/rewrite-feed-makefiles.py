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
# Last modified: Fri Mar 21 11:54:22 2014 mstenber
# Edit time:     36 min
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
    #'bird6-elsa': 'bird',
    #'hnet': 'core',
    #'hnet-dnsmasq-dhcpv6': 'dnsmasq',
    #'hnet-odhcp6c': 'odhcp6c',
    #'hnet-luasocket': 'luasocket',
    #'lualfs': 'lualfs',
    #'luamd5': 'luamd5',
    #'luavstruct': 'luavstruct'

    # Version 3 (=hnetd + babels(=hnet-babeld))
    'dist/package/network/ipv6/odhcp6c' : 'odhcp6c',
    'dist/package/network/services/odhcpd' : 'odhcpd',
    'dist/package/libs/libubox': 'libubox',
    'routing/hnetd' : 'hnetd',
    'routing/babels' : 'babels',
    'routing/ohybridproxy' : 'ohybridproxy',

    }

ts = datetime.datetime.now().strftime('%Y-%m-%d')
for owname, cname in owrt2component.items():
    component_version = shell_to_string('(cd component/%(cname)s && git rev-parse HEAD)' % locals())
    if not component_version:
        print '!!! unable to get component version for %s' % cname
        continue
    owmakefile = os.path.join('openwrt', owname, 'Makefile')
    owrt_version = shell_to_string("egrep '^PKG_SOURCE_VERSION' '%(owmakefile)s' | cut -d '=' -f 2" % locals())
    if not owrt_version:
        print '!!! unable to get openwrt version for %s' % cname
        continue
    print owname, component_version, ts
    if owrt_version != component_version:
        print 'Upgrading', cname, owrt_version, component_version
        cmd = "perl -i.bak -pe 's/^PKG_SOURCE_VERSION.*$/PKG_SOURCE_VERSION:=%(component_version)s/' '%(owmakefile)s'" % locals()
        #print cmd
        os.system(cmd)
        cmd = "perl -i.bak -pe 's/^PKG_VERSION.*$/PKG_VERSION:=%(ts)s-\$(PKG_SOURCE_VERSION)/' '%(owmakefile)s'" % locals()
        #print cmd
        os.system(cmd)
        os.unlink('%(owmakefile)s.bak' % locals())
        abase= '%s-%s-%s' % (owname, ts, component_version)
        aname = abase + '.tar.bz2'
        apath = '%s/%s' % ('openwrt/dist/dl', aname)
        try:
            f = open(apath)
        except:
            cmd = 'sh -c "(cd component/%(cname)s && git archive --format=tar --prefix=%(abase)s/ HEAD) | bzip2 -9 > %(apath)s"' % locals()
            #print '#', cmd

#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Python -*-
#
# $Id: mem2pie.py $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Tue Jun 25 11:31:38 2013 mstenber
# Last modified: Tue Jun 25 11:51:29 2013 mstenber
# Edit time:     13 min
#
"""

Minimalist filter to convert killdelta output to SVG pie chart.

Requires pygal. (easy_install pygal)

Input: killdelta output
Output: svg pie chart

"""

import re, sys, time
import pygal

def formatval(x):
    return '%.2fM' % (x / 1000.0)

mem_re = re.compile('^(\d+)\s+(\S+)\s+').match

p = pygal.Pie()
tcnt = 0
for line in sys.stdin.readlines():
    m = mem_re(line)
    if m is not None:
        (cnt, name) = m.groups()
        cnt = int(cnt)
        tcnt += cnt
        p.add(name, [{'value': cnt, 'label': '%s %s' % (name, formatval(cnt))}])

used = formatval(tcnt)
now = time.ctime()
p.title = "Memory usage %(used)s at %(now)s" % globals()
print p.render()

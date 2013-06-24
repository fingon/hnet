#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Python -*-
#
# $Id: killdelta.py $
#
# Author: Markus Stenberg <mstenber@cisco.com>
#
# Copyright (c) 2013 cisco Systems, Inc.
#
# Created:       Mon Jun 24 09:48:43 2013 mstenber
# Last modified: Mon Jun 24 09:55:59 2013 mstenber
# Edit time:     4 min
#
"""

Input: log of mem+killed lines
Output: memory used by each

"""

import re
import sys

mem_line = re.compile('^mem\s+(\d+)$').match
killed_line = re.compile('^killed\s+(.*)\s+(\d+)$').match

pname, cnt = None, None
for line in sys.stdin.readlines():
    m = mem_line(line)
    if m is not None:
        new_mem = int(m.group(1))
        if pname and new_mem != old_mem:
            print (old_mem - new_mem), pname, cnt
        old_mem = new_mem
    m = killed_line(line)
    if m is not None:
        (pname, cnt) = m.groups()
        cnt = int(cnt)


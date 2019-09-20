#!/usr/bin/env python2
#coding: utf-8

import os
import sys
import time
import math
import signal
import dns.resolver
from operator import itemgetter
from multiprocessing import Pool

rip = []
rport = 0

def     ffr(domain):
    global rip, rport
    r = dns.resolver.Resolver()
    r.timeout = 2
    r.lifetime = 2
    r.nameservers = rip
    r.port = rport
    t0 = time.time()
    res = ''
    char = '-'
    try:
        a = r.query(domain+'', 'A')
    except Exception as e:
        char = 'X'
        res = type(e).__name__
    else:
        res = a[0].to_text()
    t = time.time() - t0 # seconds
    ti = char * int(math.ceil(t*10))
    sys.stdout.write('.')
    sys.stdout.flush()
    return domain, res, ti, int(t*1000)

def     main(s, bl, nt=25):
    def sigint_handler(sig, frm):
        global flg
        flg = False
        os._exit(1)
        exit(1)
    global rip, rport
    signal.signal(signal.SIGINT, sigint_handler)
    rip = [s.split('#')[0]]
    rport = 53 if '#' not in s else int(s.split('#')[1])
    t = []
    f = open(bl)
    for line in f:
        line = ''.join(line.split())
        line = line.split(',')[0]
        t.append(line)
    f.close()
    p = Pool(int(nt))
    unb = p.map(ffr, (t))
    print '\n%s'%('-'*80)
    dommax = max([len(do) for do, _, _, _ in unb])
    avg = sum(a[3] for a in unb) / len(unb)
    if False:
        unb.sort(key=itemgetter(3), reverse=True)
    for do, re, ti, t in unb:
        tids = "(%+d)" % (t-avg)
        print("%s %4dms %s [%s] %s" % (do.ljust(dommax), t, tids.ljust(7), ti.ljust(21), re.ljust(30)))
    print("Avg/Med/Min/Max times: %d/%d/%d/%d (ms)" % (avg, unb[int(len(unb)/2)][3], min(a[3]for a in unb), max(a[3]for a in unb)))
    d = {'OK': 0}
    for u in unb:
        if u[1].count('.') != 3:
            d[u[1]] = d.get(u[1], 0) + 1
        else:
            d['OK'] += 1
    d = sorted(d.items(), key=itemgetter(1), reverse=True)
    for k, v in d:
        print("%14s: %d"%(k, v))
    return True


if  __name__ == "__main__":
    na = len(sys.argv)
    if na > 3:
        main(sys.argv[1], sys.argv[2], sys.argv[3])
    elif na > 2:
        main(sys.argv[1], sys.argv[2])
    else:
        print "usage: %s [dns] [domainslist] (number of threads)" % sys.argv[0]

#EoF

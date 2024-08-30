'''
Code taken from awesome-align
'''
import sys

src = open(sys.argv[1], encoding='utf-8').readlines()
tgt = open(sys.argv[2], encoding='utf-8').readlines()

out = open(sys.argv[3], 'w')

if not len(src) == len(tgt):
    raise ValueError('Lengths of the two input files should be the same!')

for s, t in zip(src, tgt):
    s, t = s.strip(), t.strip()
    # We don't want either to be empty
    if not s or not t:
        continue
    if len(s.split()) < 1 or len(t.split()) < 1:
        continue
    
    l = (' ||| ').join([s, t]) + '\n'
    out.write(l)
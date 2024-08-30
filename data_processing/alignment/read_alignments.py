#!/usr/bin/env python3

'''
This script reads the alignments and the parallel corpus and creates a dictionary of dictionaries
where the keys are the source words and the values are dictionaries where the keys are the target
words and the values are the counts of the alignments. This dictionary is then written to a file
in JSON format.
Use this script as follows:
python3 read_alignments.py <parallel_corpus> <alignments> <output_file>
where:
<parallel_corpus> is the path to the parallel corpus file, each line is source ||| target
<alignments> is the path to the alignments file, each line is in Pharaoh format
<output_file> is the path to the file where the dictionary will be written in JSON format

'''

import string
from collections import defaultdict
import sys
import json

f = open(sys.argv[1], "r").read().split("\n")
alignments = open(sys.argv[2], "r").read().split("\n")

source, target = list(), list()
f = [line for line in f if line != ""]
for line in f:
    if "|||" not in line:
        continue

    source.append(line.split("|||")[0].strip())
    target.append(line.split("|||")[1].strip())


dictionary = defaultdict(lambda: defaultdict(lambda: 0))

for idx in range(len(alignments)):
    # print(source[idx])
    # print(target[idx])
    if idx >= min(len(source), len(target), len(alignments)):
        continue
    source_words = source[idx].strip().split()
    target_words = target[idx].strip().split()
    align = [(int(x.split("-")[0]), int(x.split("-")[1])) for x in alignments[idx].strip().split()]
    for a in align:
        sw, tw = source_words[a[0]], target_words[a[1]]
        dictionary[sw][tw] += 1


with open(sys.argv[3], "w") as f:
    json.dump(dictionary, f, indent = 2, ensure_ascii = False)
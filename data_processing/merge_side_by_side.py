# Usage: python merge_side_by_side.py file1 file2 delimiter
import sys
with open(sys.argv[1]) as f1, open(sys.argv[2]) as f2: 
    for line in zip(f1, f2):
        line = [x.strip() for x in line]
        print(sys.argv[3].join(line).strip())
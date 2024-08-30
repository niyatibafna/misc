# This script replaces non-breaking spaces with regular spaces in a text file.
# Usage: python replace_nbsp.py <input_file> <output_file>
# Example: python replace_nbsp.py input.txt output.txt

import sys
import re

def replace_nbsp(input_file, output_file):
    with open(input_file, 'r') as f:
        text = f.read()
    text = re.sub(r'\xa0', ' ', text)
    with open(output_file, 'w') as f:
        f.write(text)
    # Check that number of lines in input and output files are the same
    with open(input_file, 'r') as f:
        input_lines = f.readlines()
    with open(output_file, 'r') as f:
        output_lines = f.readlines()
    if len(input_lines) != len(output_lines):
        print(f'WARNING: Number of lines in input and output files are different')
    else:
        print(f'Checked that number of lines in input and output files are the same')

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    replace_nbsp(input_file, output_file)
    
    
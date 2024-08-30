#!/bin/bash
# Take an input file and split it into training and testing files

# Usage: data_split.sh <input_file> <output_dir> <train_lines> <dev_lines> <test_lines>
# OR
# Usage: data_split.sh <input_file> <output_dir> <train_frac> <dev_frac> <test_frac>

if [ "$#" -ne 5 ]; then
    echo "Usage: data_split.sh <input_file> <output_dir> <train_lines> <dev_lines> <test_lines>"
    echo "OR"
    echo "Usage: data_split.sh <input_file> <output_dir> <train_frac> <dev_frac> <test_frac>"
    exit 1
fi

input_file=$1
output_dir=$2
train_lines=$3
dev_lines=$4
test_lines=$5

if [[ $train_lines =~ ^0\.[0-9]+$ ]]; then
    # If any of the lines are less than 1, then we assume that the user has passed in fractions
    train_frac=$train_lines
    dev_frac=$dev_lines
    test_frac=$test_lines
    total_frac=$(echo "$train_frac + $dev_frac + $test_frac" | bc)
    if [ $(echo "$total_frac > 1" | bc) -eq 1 ]; then
        echo "Fractions must sum to 1"
        exit 1
    fi
    max_lines=$(wc -l $input_file | awk '{print $1}')
    train_lines=$(echo "$max_lines * $train_frac" | bc | awk '{print int($1)}')
    dev_lines=$(echo "$max_lines * $dev_frac" | bc | awk '{print int($1)}')
    test_lines=$(echo "$max_lines * $test_frac" | bc | awk '{print int($1)}')
fi

# Create the output directory
mkdir -p $output_dir

# First shuffle the input file
shuf $input_file | head -n $(($train_lines+$dev_lines+$test_lines)) > $output_dir/shuffled.txt

# Split the input file into training, dev, and test files
head -n $train_lines $output_dir/shuffled.txt > $output_dir/train
tail -n +$(($train_lines+1)) $output_dir/shuffled.txt | head -n $dev_lines > $output_dir/dev
tail -n +$(($train_lines+$dev_lines+1)) $output_dir/shuffled.txt | head -n $test_lines > $output_dir/test

echo "Created train, dev, and test files in $output_dir"
echo "Number of lines in input file: $(wc -l $input_file)"
echo "Number of lines in train file: $(wc -l $output_dir/train)"
echo "Number of lines in dev file: $(wc -l $output_dir/dev)"
echo "Number of lines in test file: $(wc -l $output_dir/test)"

# Remove the shuffled file
rm $output_dir/shuffled.txt

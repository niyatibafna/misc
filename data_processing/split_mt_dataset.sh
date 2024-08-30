#!/bin/bash
# Take source and target input files (aligned), shuffle, split into train, dev, and test files

# Usage: split_mt_dataset.sh <source_file> <target_file> <source_output_dir> <target_output_dir> <train_lines> <dev_lines> <test_lines>
# OR
# Usage: split_mt_dataset.sh <source_file> <target_file> <source_output_dir> <target_output_dir> <train_frac> <dev_frac> <test_frac>

if [ "$#" -ne 7 ]; then
    echo "Usage: split_mt_dataset.sh <source_file> <target_file> <source_output_dir> <target_output_dir> <train_lines> <dev_lines> <test_lines>"
    echo "OR"
    echo "Usage: split_mt_dataset.sh <source_file> <target_file> <source_output_dir> <target_output_dir> <train_frac> <dev_frac> <test_frac>"
    exit 1
fi

# Get the input arguments
source_file=$1
target_file=$2
source_output_dir=$3
target_output_dir=$4
train_lines=$5
dev_lines=$6
test_lines=$7

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
    max_lines=$(wc -l $source_file | awk '{print $1}') # we assume that the source and target files have the same number of lines
    train_lines=$(echo "$max_lines * $train_frac" | bc | awk '{print int($1)}')
    dev_lines=$(echo "$max_lines * $dev_frac" | bc | awk '{print int($1)}')
    test_lines=$(echo "$max_lines * $test_frac" | bc | awk '{print int($1)}')
fi

# Make output directories
mkdir -p $source_output_dir
mkdir -p $target_output_dir

sep="xxxxx"
# Paste the source and target files together
# awk 'BEGIN {OFS="xxxxx"} {print $0}' $source_file $target_file > $source_output_dir/merged_file.txt
# paste -d "xxxxx" $source_file $target_file > $source_output_dir/merged_file.txt

python /home/nbafna1/misc/merge_side_by_side.py $source_file $target_file $sep > $source_output_dir/merged_file.txt

# # Count the number of lines in the input files
# wc -l $source_output_dir/merged_file.txt
# head -n 10 $source_output_dir/merged_file.txt

# Shuffle the pasted dataset
shuf $source_output_dir/merged_file.txt | head -n $(($train_lines+$dev_lines+$test_lines)) > $source_output_dir/shuffled.txt

# Split the input file into training, dev, and test files
head -n $train_lines $source_output_dir/shuffled.txt > $source_output_dir/st_train
tail -n +$(($train_lines+1)) $source_output_dir/shuffled.txt | head -n $dev_lines > $source_output_dir/st_dev
tail -n +$(($train_lines+$dev_lines+1)) $source_output_dir/shuffled.txt | head -n $test_lines > $source_output_dir/st_test

# Separate the source and target files
awk -F $sep '{print $1}' $source_output_dir/st_train > $source_output_dir/train
awk -F $sep '{print $2}' $source_output_dir/st_train > $target_output_dir/train
awk -F $sep '{print $1}' $source_output_dir/st_dev > $source_output_dir/dev
awk -F $sep '{print $2}' $source_output_dir/st_dev > $target_output_dir/dev
awk -F $sep '{print $1}' $source_output_dir/st_test > $source_output_dir/test
awk -F $sep '{print $2}' $source_output_dir/st_test > $target_output_dir/test

# Remove the shuffled file
rm $source_output_dir/shuffled.txt
# Remove the merged file
rm $source_output_dir/merged_file.txt
# Remove the split files
rm $source_output_dir/st_train
rm $source_output_dir/st_dev
rm $source_output_dir/st_test

# Count the number of lines in the output files
echo "Number of lines in source file:" $(wc -l $source_file)
echo "Number of lines in target file:" $(wc -l $target_file)
echo "Number of lines in train source file:" $(wc -l $source_output_dir/train)
echo "Number of lines in train target file:" $(wc -l $target_output_dir/train)
echo "Number of lines in dev source file:" $(wc -l $source_output_dir/dev)
echo "Number of lines in dev target file:" $(wc -l $target_output_dir/dev)
echo "Number of lines in test source file:" $(wc -l $source_output_dir/test)
echo "Number of lines in test target file:" $(wc -l $target_output_dir/test)

# Print the first 10 lines of each file
echo "First 10 lines of train source file:"
head -n 10 $source_output_dir/train
echo "\n\n\n\n"
echo "First 10 lines of train target file:"
head -n 10 $target_output_dir/train
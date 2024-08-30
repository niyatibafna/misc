#!/usr/bin/env bash

# This is a *TEMPLATE* for running alignment with awesome-align.
# Note that awesome-align needs to be installed and the environment activated before running this script.
# (damt has awesome-align installed)
# For a new environment, go to projects/awesome-align and run
# pip install -r requirements.txt
# python setup.py install

#$ -N align
#$ -wd <working_dir>
#$ -m e
#$ -j y -o qsub_align.out

# Fill out RAM/memory (same thing) request,
# the number of GPUs you want,
# and the hostnames of the machines for special GPU models.
#$ -l ram_free=20G,mem_free=30G,gpu=1,hostname=b1[123456789]|c0*|c1[123456789]

# Submit to GPU queue
#$ -q g.q


cd <working_dir>
conda activate <env_name>

# Input files to format_raw.py with simply raw text, one sentence per line, aligned by line number
source_file="" 
target_file=""
# This file will be created by format_raw.py
INFILE="*formatted_source_target.txt"

# This file will be created by awesome-align
ALIGN_OUTPUT_FILE="/export/b08/nbafna1/projects/courses/601.764-multilingual-nlp/hw1/using_awesome-align/aa_alignments.txt"

# This file will be created by read_alignments.py
OUTFILE="*json" # Or whatever else

AWESOME_ALIGN_PATH="/" # Path to awesome-align
MODEL_NAME_OR_PATH=bert-base-multilingual-cased

python3 /home/nbafna1/misc/alignment/format_raw.py $source_file $target_file $INFILE # This code creates the $INFILE using text.txt and du.txt

# Run awesome-align
CUDA_VISIBLE_DEVICES=0 $AWESOME_ALIGN_PATH \
    --output_file=$ALIGN_OUTPUT_FILE \
    --model_name_or_path=$MODEL_NAME_OR_PATH \
    --data_file=$INFILE \
    --extraction 'softmax' \
    --batch_size 32

# Run whatever code required for processing the Pharaoh alignments produced by the above
# e.g.
python3 do_something_with_alignments.py $INFILE $ALIGN_FILE $OUTFILE # This code uses $INFILE and $ALIGN_FILE to create some kind of output 

# If we want a bilingual source->target dictionary, use
python3 /home/nbafna1/misc/alignment/read_alignments.py $INFILE $ALIGN_FILE $OUTFILE
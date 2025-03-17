#!/usr/bin/env bash

# This is a *TEMPLATE* for running alignment with fast-align.

####### FOR SGE:
#$ -N align
#$ -wd <working_dir>
#$ -m e
#$ -j y -o qsub_align.out

# Fill out RAM/memory (same thing) request,
# the number of GPUs you want,
# and the hostnames of the machines for special GPU models.
#$ -l ram_free=20G,mem_free=30G,hostname=b1[123456789]|c0*|c1[123456789]

####### FOR SLURM:
#SBATCH --job-name=align    # create a short name for your job
#SBATCH --nodes=1              # node count
#SBATCH --ntasks=1            # total number of tasks across all nodes
#SBATCH --cpus-per-task=1       # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --partition=cpu          # Name of the partition
#SBATCH --mem=50G                # Total memory allocated
#SBATCH --hint=multithread       # we get logical cores (threads) not physical (cores)
#SBATCH --time=0:30:00          # total run time limit (HH:MM:SS)
#SBATCH --array=0-33
#SBATCH --output=qsub_logs/align_%a.out   # output file name
#SBATCH --error=qsub_logs/align_%a.out    # error file name



cd <working_dir>
conda activate <env_name>

# Existing input files to format_raw.py with simply raw text, one sentence per line, aligned by line number
source_file="" 
target_file=""
# This file will be created by format_raw.py
INFILE="*formatted_source_target.txt" # (It's called INFILE because it's the input file to fast-align)

# This file will be created by fast-align
ALIGN_OUTPUT_FILE="/export/b08/nbafna1/projects/courses/601.764-multilingual-nlp/hw1/using_fast-align/fa_alignments.txt"

# This file will be created by read_alignments.py or whatever thing you want to do with the alignments
OUTFILE="*json" # Or whatever else

FAST_ALIGN_PATH="/export/b08/nbafna1/projects/fast_align/build/./fast_align" # Path to fast-align

python3 /home/nbafna1/misc/data_processing/alignment/format_raw.py $source_file $target_file $INFILE # This code creates the $INFILE using text.txt and du.txt

# Run fast-align
$FAST_ALIGN_PATH -i $INFILE -v -o -d > $ALIGN_OUTPUT_FILE # This code creates the $ALIGN_OUTPUT_FILE using $INFILE
# For alignment with reverse model:
# $FA_DIR -i $INFILE -r -v -o -d > $ALIGN_OUTPUT_FILE

# Run whatever code required for processing the Pharaoh alignments produced by the above
# e.g.
# python3 do_something_with_alignments.py $INFILE $ALIGN_FILE $OUTFILE # This code uses $INFILE and $ALIGN_FILE to create some kind of output 

# If we want a bilingual source->target dictionary, use
python3 /home/nbafna1/misc/data_processing/alignment/read_alignments.py $INFILE $ALIGN_FILE $OUTFILE
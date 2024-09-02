#!/usr/bin/env bash
#$ -N check_cuda_availability
#$ -wd /home/nbafna1/
#$ -m e
#$ -j y -o qsub_log

# Fill out RAM/memory (same thing) request,
# the number of GPUs you want,
# and the hostnames of the machines for special GPU models.
#$ -l ram_free=1G,mem_free=1G,gpu=1,hostname=!c08*&!c07*&!c04*&!c25*&c*

# Submit to GPU queue
#$ -q g.q

# Assign a free-GPU to your program (make sure -n matches the requested number of GPUs above)
source ~/.bashrc
conda deactivate

# Put the name of the environment to be tested here
conda activate sandbox
source /home/gqin2/scripts/acquire-gpu 1

which python

# Check if CUDA is available
echo "Checking if CUDA is available..."
python -c "import torch; print(torch.cuda.is_available())"

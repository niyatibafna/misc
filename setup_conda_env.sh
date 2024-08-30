#!/usr/bin/env bash 

# Note: Running like this: source setup_conda_env.sh <environment_name> will allow the script to activate the environment 
# in the running shell. Uncomment below.

# # Access the first argument
# environment_name=$1

# # Check if an argument is provided
# if [ $# -eq 0 ]; then
#     echo "Usage: $0 <environment_name>"
#     exit 1
# fi
# conda activate $environment_name

# OR

# Before running this script, create and activate conda environment
# conda create -y -n $environment_name
# echo "Activating conda environment: $environment_name"
# conda activate $environment_name

## Then run this script i.e. ``nohup bash setup_conda_env.sh``

set -euxo pipefail

# Install PyTorch and other dependencies
echo "Installing PyTorch and other dependencies"

### !!! Choose which PyTorch version to install based on your CUDA version !!!
conda install -y pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=10.2 -c pytorch
# conda install -y pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
# conda install -y pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

# Install transformers and tensorboard
echo "INSTALLING transformers AND tensorboard..."
conda install -y -c huggingface transformers
conda install -y tensorboard

# pip packages
echo "INSTALLING pip PACKAGES..."

pip install -U evaluate
pip install -U accelerate 
pip install -U datasets

pip install -U scikit-learn matplotlib seaborn pandas

## If speech environment, install the following
pip install -U librosa
pip install -U soundfile


echo "Environment setup complete."
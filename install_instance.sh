#!/bin/bash


########################
#Ding Shuya, Sept 2018
########################



########################
# Configure the VM machine with Ubuntu 16.04 LTS, Tesla K80 GPU
########################

# Command line
# source ./install_instance.sh



##################
# Install CUDA 9.0
##################

cd
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
chmod +x cuda_9.0.176_384.81_linux-run
./cuda_9.0.176_384.81_linux-run --extract=$HOME
sudo ./cuda-linux.9.0.176-22781540.run
sudo ./cuda-samples.9.0.176-22781540-linux.run
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
sudo bash -c "echo /usr/local/cuda/lib64/ > /etc/ld.so.conf.d/cuda.conf"
sudo ldconfig
# sudo vim /etc/environment
# add :/usr/local/cuda/bin (including the ":") at the end of the PATH="/blah:/blah/blah" string (inside the quotes).

##################
# Install CUDNN 9.0 Download cudnn runtime, deb, doc
##################
sudo dpkg -i libcudnn7_7.3.1.20-1+cuda9.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.3.1.20-1+cuda9.0_amd64.deb
sudo dpkg -i libcudnn7-doc_7.3.1.20-1+cuda9.0_amd64.deb

########################
# Install miniconda
########################

sudo apt-get update
sudo apt-get -y upgrade
curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x ~/miniconda.sh
./miniconda.sh -b
echo "PATH=~/miniconda3/bin:$PATH" >> ~/.bashrc 
source ~/.bashrc 



########################
# Install python libraries
########################

conda install -y python=3.6 numpy scipy ipython mkl seaborn pandas matplotlib scikit-learn networkx
conda install -y pytorch=0.4.1 torchvision cuda92 -c pytorch


########################
# Download project from github
########################

conda install -y git 
git clone https://github.com/di0002ya/ADM

########################
# Install torch
########################
curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh
source ~/.bashrc

########################
# Install Jupyter
########################
sudo apt-get install build-essential python3-dev
sudo apt-get install python3-pip
pip3 install jupyter -i http://pypi.douban.com/simple


########################
# Install iTorch
########################
sudo apt-get install libzmq3-dev
git clone https://github.com/facebook/iTorch.git
cd iTorch
luarocks make


########################
# Jupyter Configuration
########################

jupyter notebook --generate-config
echo "c = get_config()" >> .jupyter/jupyter_notebook_config.py 
echo "c.NotebookApp.ip = '*'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8888" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.token='deeplearning'" >> .jupyter/jupyter_notebook_config.py




########################
# Run notebooks remotely
########################

# tmux
#tmux new -s deeplearning -d
#tmux send-keys "jupyter notebook" C-m
# use any web browser : http://xx.xx.xx.xx:8888

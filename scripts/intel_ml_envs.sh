# !/bin/bash
# Usage: bash intel_ml_envs.sh

# Note: in conda 4.6, the post-activate file is sourced every
# time conda is run, not just every time we activate the
# environment, as in 4.3.

# Add conda, activate to PATH
# conda_path=`find / -wholename *anaconda/bin/conda`
# export PATH=${conda_path::-6}:$PATH
export PATH=/data/anaconda/condabin/:$PATH


#### Create Python 3 TensorFlow env ####
yes 'y' | conda create -n intel_tensorflow_p37 python=3.7

# Create a post-activate script to install all packages
TF_LOCATION=/data/anaconda/envs/intel_tensorflow_p37
mkdir -p $TF_LOCATION/etc/conda/activate.d/
touch $TF_LOCATION/etc/conda/activate.d/install_tf3.sh

# Write install instructions to post-activate file
cat <<EOT >> $TF_LOCATION/etc/conda/activate.d/install_tf3.sh
# !/bin/bash
# Check if TensorFlow is already installed
if ! conda list | grep -q 'intel-tensorflow';
then
    echo "Installing Intel Optimized TensorFlow..."
    echo "This is a one-time installation, and may take a minute..."
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    # Issues with conda install, use pip instead
    pip install intel-tensorflow==1.15.2
fi

EOT

#### Create Python 3 MXNet env ####
yes 'y' | conda create -n intel_mxnet_p37 python=3.7

# Create a post-activate script to install all packages

MX_LOCATION=/data/anaconda/envs/intel_mxnet_p37
mkdir -p $MX_LOCATION/etc/conda/activate.d/
touch $MX_LOCATION/etc/conda/activate.d/install_mx3.sh


# Write install instructions to post-activate file
cat <<EOT >> $MX_LOCATION/etc/conda/activate.d/install_mx3.sh
# !/bin/bash
# Check if MXNet is already installed
if ! conda list | grep -q 'mxnet-mkl';
then
    echo "Installing Intel Optimized MXNet..."
    echo "This is a one-time installation, and may take a minute..."
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    pip install mxnet-mkl
fi

EOT


#### Create Python 3 PyTorch env ####
## Must build the environment with supporting packages first - doesn't add much extra time
yes 'y' | conda create -n intel_pytorch_p37 python=3.7

# Create a post-activate script to install all packages

PT_LOCATION=/data/anaconda/envs/intel_pytorch_p37
mkdir -p $PT_LOCATION/etc/conda/activate.d/
touch $PT_LOCATION/etc/conda/activate.d/install_pt3.sh


# Write install instructions to post-activate file
cat <<EOT >> $PT_LOCATION/etc/conda/activate.d/install_pt3.sh
# !/bin/bash
# Check if PyTorch is already installed
if ! conda list | grep -q '^torch';
then
    echo "Installing Intel Optimized PyTorch..."
    echo "This is a one-time installation, and may take a minute..."
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    yes 'y' | conda install pytorch-cpu torchvision-cpu -c pytorch
fi

EOT


#### Create Python 3 TensorFlow env with default TF for benchmarking purposes ####
yes 'y' | conda create -n tensorflow_p37 python=3.7


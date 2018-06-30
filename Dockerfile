FROM nvidia/cuda:9.0-base-ubuntu16.04
MAINTAINER "Max Woolf"

RUN apt-get update && apt-get install -y wget ca-certificates \
    git curl vim python3-dev python3-pip libopencv-dev python-opencv \
    libfreetype6-dev libpng12-dev libhdf5-dev openmpi-bin \
    cuda-command-line-tools-9-0 \
    cuda-cublas-9-0 \
    cuda-cufft-9-0 \
    cuda-curand-9-0 \
    cuda-cusolver-9-0 \
    cuda-cusparse-9-0 \
    libcudnn7=7.0.5.15-1+cuda9.0 \
    && \
    rm -rf /var/lib/apt/lists/*
    
RUN pip3 install --upgrade pip
RUN pip3 --no-cache-dir install tensorflow-gpu
RUN pip3 --no-cache-dir install numpy pandas sklearn matplotlib seaborn \
    jupyter pyyaml h5py ipykernel pydot graphviz scikit-image scipy cython talos hyperas

# Keras
RUN pip3 --no-cache-dir install keras

# CNTK
RUN pip3 install https://cntk.ai/PythonWheel/GPU-1bit-SGD/cntk-2.4-cp35-cp35m-linux_x86_64.whl

# textgenrnn (must be installed after Keras)
RUN pip3 --no-cache-dir install textgenrnn

# Jupyter and Tensorboard ports
EXPOSE 8888 6006

# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/
COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

# Create folder for Keras i/o
WORKDIR /keras
VOLUME /keras

# Set CNTK backend for Keras
ENV KERAS_BACKEND=cntk

# Set locale to UTF-8 for text:
# https://askubuntu.com/a/601498
RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER "Max Woolf"

RUN apt-get update && apt-get install -y wget ca-certificates \
    git curl vim python3-dev python3-pip \
    libfreetype6-dev libpng12-dev libhdf5-dev openmpi-bin

RUN pip3 install --upgrade pip
RUN pip3 install tensorflow-gpu
RUN pip3 install numpy pandas sklearn h5py

# Keras w/ CNTK
RUN pip3 install git+https://github.com/souptc/keras.git

# CNTK w/ 1bit-SGD
RUN pip3 install https://cntk.ai/PythonWheel/GPU-1bit-SGD/cntk-2.0-cp35-cp35m-linux_x86_64.whl

# Create folder for Keras files
WORKDIR /keras
VOLUME /keras

# Set CNTK backend for Keras
ENV KERAS_BACKEND=cntk
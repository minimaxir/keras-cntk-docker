FROM microsoft/cntk:2.2-gpu-python3.5-cuda8.0-cudnn6.0
MAINTAINER "Max Woolf"

RUN apt-get update && apt-get install -y wget ca-certificates \
    git curl vim \
    libfreetype6-dev libpng12-dev libhdf5-dev openmpi-bin


RUN python3 get-pip.py
RUN pip3 --no-cache-dir install tensorflow-gpu
RUN pip3 --no-cache-dir install numpy pandas sklearn matplotlib seaborn jupyter pyyaml h5py ipykernel

# Keras
RUN pip3 install git+https://github.com/fchollet/keras.git

# CNTK
# RUN pip3 install https://cntk.ai/PythonWheel/GPU/cntk-2.2-cp35-cp35m-linux_x86_64.whl

# textgenrnn (must be installed after Keras)
RUN pip3 --no-cache-dir install textgenrnn reactionrnn

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
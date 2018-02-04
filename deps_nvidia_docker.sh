#!/bin/bash

if lspci | grep -i 'nvidia'
then
  echo "\nNVIDIA GPU is likely present."
else
  echo "\nNo NVIDIA GPU was detected. Exiting ...\n"
  exit 1
fi

echo "\nChecking for NVIDIA drivers ..."
if ! nvidia-smi ; then
  echo "Error: nvidia-smi is not installed, or not working."

  apt-get update
  apt-get install -y curl build-essential

  curl -O -s http://us.download.nvidia.com/XFree86/Linux-x86_64/384.111/NVIDIA-Linux-x86_64-384.111.run
  sudo sh ./NVIDIA-Linux-x86_64-384.111.run -a --ui=none --no-x-check && rm NVIDIA-Linux-x86_64-384.111.run

  echo "\nInstalled NVIDIA drivers."
else
  echo "NVIDIA driver is already installed."
fi

echo "\nChecking docker ..."
if ! [ -x "$(command -v docker)" ]; then
  echo "docker is not installed."
  apt-get -y install apt-transport-https ca-certificates curl
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update

  apt-get -y install docker-ce
  echo "\nInstalled docker."
else
  echo "docker is already installed."
fi
echo "\nChecking nvidia-docker ..."
if ! [ -x "$(command -v nvidia-docker)" ]; then
  echo "nvidia-docker is not installled."

  # https://nvidia.github.io/nvidia-docker/
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update

  # https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)
  sudo apt-get install nvidia-docker2
  sudo pkill -SIGHUP dockerd

  echo "\nInstalled nvidia-docker."
else 
  echo "nvidia-docker is already installed."
fi
echo "\nAll dependencies are installed."
echo "\nTry running: \n\tdocker run --runtime=nvidia --rm nvidia/cuda nvidia-smi\n"

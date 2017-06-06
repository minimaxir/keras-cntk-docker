# keras-cntk-docker

Docker container for keras + cntk intended for nvidia-docker. Based off of 
Durgesh Mankekar's minimal [keras container](https://github.com/durgeshm/dockerfiles/tree/master/jupyter-keras-gpu) + corresponding [blog post](https://medium.com/google-cloud/containerized-jupyter-notebooks-on-gpu-on-google-cloud-8e86ef7f31e9).

## Usage

Here's how to set up the container from scratch on any GPU instance:

```sh
curl -O -s https://gist.githubusercontent.com/durgeshm/b149e7baec4d4508eb4b2914d63018c7/raw/798aadbb54b451abcaba9bfeb833327fa4b3d53b/deps_nvidia_docker.sh
sudo sh deps_nvidia_docker.sh
sudo nvidia-docker run -it --rm -v $(pwd)/:/keras --name keras minimaxir/keras-cntk python3 [x].py
```

Install script was used by Mankekar for the blog post above.

Where [x] is the Python script on the server.
FROM nvidia/cuda:10.0-devel-ubuntu18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV CUDNN_VERSION 7.5.0.56
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        sudo \
        python \
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*
ENV HOME /home
ENV REPOSITORY_PATH $HOME/object-detection
ENV DARKNET_PATH $REPOSITORY_PATH/darknet
RUN cd $HOME && git clone https://github.com/enesozi/object-detection $REPOSITORY_PATH &&  \
    cd $REPOSITORY_PATH && git submodule update --init && cp Makefile $DARKNET_PATH    &&  \
    cd $DARKNET_PATH  && make
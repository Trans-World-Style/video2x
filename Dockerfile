FROM nvidia/vulkan:1.3-470
ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_VERSION=3.27.0-rc4
# python3 이상
ENV PYTHON_VERSION=3.7


# install python 3.7
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
    apt-get update && \
    apt-get install -y software-properties-common &&\
    apt-add-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y wget unzip libssl-dev ninja-build && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-distutils && \
    apt-get install -y python3-pip && \
    python3.7 -m pip install pip && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 \

## install cmake
#RUN apt-get update && \
#    apt-get install -y wget && \
#    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
#    chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
#    ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --prefix=/usr/local && \
#    rm cmake-${CMAKE_VERSION}-linux-x86_64.sh


COPY [".", "/workspace"]
WORKDIR /workspace

RUN pip install --upgrade pip && \
    pip install pdm

#RUN

#RUN wget https://bootstrap.pypa.io/get-pip.py
#RUN python3.7 get-pip.py && \
#    rm get-pip.py

# docker run --gpus all -itd --name video -v $PWD:/workspace -p 8000:12231 video_image
# docker run --gpus all -itd --name video -v $PWD/video2x:/workspace -p 8000:12231 k4yt3x/video2x:latest /bin/bash
#docker pull k4yt3x/video2x:latest
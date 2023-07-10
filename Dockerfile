FROM nvidia/vulkan:1.3-470
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
    apt-get update && \
    apt-get install -y software-properties-common &&\
    apt-add-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.7 python3.7-distutils && \
    apt-get install -y python3-pip && \
    python3.7 -m pip install pip && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 \

RUN pip install --upgrade pip && \
    pip install pdm

#COPY . /workspace
#WORKDIR /workspace

#RUN wget https://bootstrap.pypa.io/get-pip.py
#RUN python3.7 get-pip.py && \
#    rm get-pip.py

# docker run --gpus all -itd --name video -v $PWD:/workspace -p 8000:12231 video_image
# docker run --gpus all -itd --name video -v $PWD/video2x:/workspace -p 8000:12231 k4yt3x/video2x:latest /bin/bash
#docker pull k4yt3x/video2x:latest
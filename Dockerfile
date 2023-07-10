FROM nvidia/vulkan:1.3-470
ENV DEBIAN_FRONTEND=noninteractive
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
#    apt-get update && \
#    apt-get install -y software-properties-common &&\
#    apt-add-repository -y ppa:deadsnakes/ppa && \
#    apt-get update && \
#    apt-get install -y python3.7 && \
#    rm -rf /var/lib/apt/lists/*
#
#RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
#
#RUN wget https://bootstrap.pypa.io/get-pip.py
#RUN python3.7 get-pip.py && \
#    rm get-pip.py

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
# 패키지 리스트 업데이트
RUN apt-get update

# software-properties-common 설치
RUN apt-get install -y software-properties-common

# Python 3.7을 설치할 수 있도록 PPA를 추가
RUN add-apt-repository ppa:deadsnakes/ppa

# 패키지 리스트 업데이트
RUN apt-get update

# Python 3.7 및 필요한 라이브러리 설치
RUN apt-get install -y python3.7 python3.7-dev wget

# python 명령어가 python3.7을 가리키도록 설정
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# pip 설치 (Python3.7에 대응)
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

# docker run --gpus all -itd --name video -v $PWD:/workspace -p 8000:12231 video_image
# docker run --gpus all -itd --name video -v $PWD/video2x:/workspace -p 8000:12231 k4yt3x/video2x:latest /bin/bash
#docker pull k4yt3x/video2x:latest
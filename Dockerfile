FROM nvidia/vulkan:1.3-470
RUN apt-get update && \
    apt-get install software-properties-commom &&\
    apt-add-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.7
# docker run --gpus all -itd --name video -v $PWD:/workspace -p 8000:12231 video_image
# docker run --gpus all -itd --name video -v $PWD/video2x:/workspace -p 8000:12231 k4yt3x/video2x:latest /bin/bash
#docker pull k4yt3x/video2x:latest
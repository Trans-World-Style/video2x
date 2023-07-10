# Name: Video1X Dockerfile
# Creator: K4YT3X
# Date Created: February 3, 2022
# Last Modified: March 28, 2022
# Patched by plambeto: April 10, 2022

# stage 1: build the python components into wheels
FROM docker.io/nvidia/vulkan:1.2.133-450 AS builder
ENV DEBIAN_FRONTEND=noninteractive
ENV DISTRO=ubuntu1804
ENV ARCH=x86_64

COPY . /video2x
WORKDIR /video2x

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/$DISTRO/$ARCH/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-key del 7fa2af80 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.8 python3-pip python3-opencv python3-pil \
        python3.8-dev libvulkan-dev glslang-dev glslang-tools \
        build-essential swig \
    && pip install pdm-backend \
    && pip wheel -w /wheels wheel pdm-pep517 .

# stage 2: install wheels into the final image
FROM docker.io/nvidia/vulkan:1.2.133-450
ENV DEBIAN_FRONTEND=noninteractive
ENV VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json\
:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json\
:/usr/share/vulkan/icd.d/intel_icd.x86_64.json
ENV NVIDIA_DRIVER_MAJOR_VERSION=460
ENV NVIDIA_DRIVER_VERSION=460.91.03
ENV DISTRO=ubuntu1804
ENV ARCH=x86_64

COPY --from=builder /var/lib/apt/lists* /var/lib/apt/lists/
COPY --from=builder /wheels /wheels
COPY --from=builder /video2x /video2x
WORKDIR /video2x

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/$DISTRO/$ARCH/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb
RUN rm /etc/apt/sources.list.d/cuda.list && \
    apt-key del 7fa2af80 && \
    apt-get update && \
    apt install -y --allow-downgrades \
        cuda-drivers-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-1 nvidia-driver-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        libnvidia-gl-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 nvidia-dkms-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        nvidia-kernel-source-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 libnvidia-compute-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        libnvidia-extra-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 nvidia-compute-utils-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        libnvidia-decode-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 libnvidia-encode-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        nvidia-utils-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 xserver-xorg-video-nvidia-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        libnvidia-cfg1-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 libnvidia-ifr1-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        libnvidia-fbc1-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 libnvidia-common-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 \
        nvidia-kernel-common-${NVIDIA_DRIVER_MAJOR_VERSION}=${NVIDIA_DRIVER_VERSION}-0ubuntu1 && \
    apt-get install -y --no-install-recommends \
        python3-pip python3.8-dev \
        python3-opencv python3-pil \
        mesa-vulkan-drivers ffmpeg \
    && pip install --no-cache-dir --no-index -f /wheels . \
    && apt-get clean \
    && rm -rf /wheels /video2x /var/lib/apt/lists/*

WORKDIR /host
#ENTRYPOINT ["/usr/bin/python3.8", "-m", "video2x"]

# docker run --gpus all -itd --name video -v $PWD/video2x:/workspace -p 8000:12231 nvidia/cuda:11.2.2-devel-ubuntu20.04
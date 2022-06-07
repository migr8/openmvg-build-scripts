FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

WORKDIR /tmp

RUN apt update -y -qq && \
    apt upgrade -y -qq --no-install-recommends && \
    apt install -y -qq \
        gcc-10 \
        g++-10 \
        git \
        wget \
        cmake \
        python3-typing-extensions \
        libx11-dev \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        libc++-10-dev \
        libc++abi-10-dev \
        libopengl-dev \
        libgl-dev \
        libgles-dev \
        libxi-dev \
        curl \
        jq \
        patchelf \
        zlib1g-dev \
        python3-yaml \
        git-lfs \
        clang-format \
        lsb-release \
        unzip \
        ninja-build \
        libglu-dev && \
    apt remove -y -qq gcc-9 && \
    apt remove -y -qq g++-9 && \
    apt autoremove -y -qq && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/local/bin/g++ g++ /usr/bin/g++-10 50 && \
    update-alternatives --install /usr/local/bin/gcc gcc /usr/bin/gcc-10 50 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-10 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-10 50

RUN VERSION=3.23.0 && \
    wget -q https://github.com/Kitware/CMake/releases/download/v$VERSION-rc5/cmake-$VERSION-rc5-linux-x86_64.tar.gz && \
    tar -xf cmake-$VERSION-rc5-linux-x86_64.tar.gz && \
    cp -r cmake-$VERSION-rc5-linux-x86_64/* /usr/ && \
    rm -r /tmp/*

RUN useradd --create-home --shell /bin/bash openmvg
USER openmvg
WORKDIR /home/openmvg
COPY . .


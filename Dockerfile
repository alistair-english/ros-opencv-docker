FROM ros:melodic-ros-base

# Install deps
RUN apt-get update && apt-get install -y \
    # build:
    build-essential \
    # required:
    cmake \
    git \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    # optional:
    python3-dev \
    python3-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-22-dev \
    && rm -rf /var/lib/apt/lists/

# OpenCV version
ARG OPENCV_VERSION="3.4.8"
ENV OPENCV_VERSION $OPENCV_VERSION

# Download source
RUN cd /tmp && \
    git clone --branch $OPENCV_VERSION --depth 1 https://github.com/opencv/opencv.git && \
    git clone --branch $OPENCV_VERSION --depth 1 https://github.com/opencv/opencv_contrib.git

# Install
WORKDIR /tmp/opencv/build
RUN cmake \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D CMAKE_BUILD_TYPE=RELEASE \
-D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules/ \
-D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D WITH_JASPER=OFF \
-D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
-D PYTHON3_EXECUTABLE=/usr/bin/python3 \
-D PYTHON_INCLUDE_DIR=/usr/include/python3.6 \
-D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.6m \
-D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
-D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/nfumpy/core/include/ \
..

RUN make -j $(nproc --all) && make install && rm -rf /tmp/*
WORKDIR /

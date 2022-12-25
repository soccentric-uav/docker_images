FROM ubuntu:18.04

MAINTAINER Sandesh Ghimire <sghimire@endiag.com>

# build with docker build --build-arg PETA_VERSION=2019.1 --build-arg PETA_RUN_FILE=petalinux-v2019.1-final-installer.run -t petalinux:2019.1 .

ARG UBUNTU_MIRROR=mirror.math.ucdavis.edu

ENV LANG=en_US.utf8

#install dependences:
RUN sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list && \
  dpkg --add-architecture i386 && apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  build-essential \
  sudo \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  update-inetd \
  libssl-dev \
  flex \
  bison \
  mtools \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  zlib1g:i386 \
  libgtk2.0-0 \
  screen \
  pax \
  diffstat \
  xvfb \
  xterm \
  texinfo \
  gzip \
  unzip \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  libtool-bin \
  locales \
  kmod \
  git \
  rsync \
  libconfuse-dev \
  dosfstools \
  bc \
  python \
  python3 \
  u-boot-tools \
  libconfuse-dev \
  binfmt-support debootstrap dosfstools dpkg-dev gettext-base git \
  mtools parted python3 quilt qemu-user-static reprepro sudo \
  git-buildpackage pristine-tar sbuild schroot 




RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado && \
  usermod -aG sudo vivado && \
  echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN cd /tmp &&  git clone https://github.com/pengutronix/genimage.git &&\
  cd /tmp/genimage &&\
  ./autogen.sh &&\
  ./configure &&\
  make &&\
  sudo make install  


RUN sudo apt install python3-pip -y

RUN git clone https://github.com/siemens/kas.git /kas 
RUN chmod -R o-w /kas

RUN apt install python3-pip python3-jsonschema -y 
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade wheel
RUN pip3 install --upgrade kconfiglib
RUN pip3 install --upgrade /kas 
RUN kas --version

RUN pip3 --proxy=$https_proxy install --no-deps kconfiglib && \
    pip3 --proxy=$https_proxy install --no-deps /kas && kas --version && \
    rm -rf $(pip3 cache dir)

RUN ln -s /kas/contrib/oe-git-proxy /usr/bin/

ENV GIT_PROXY_COMMAND="oe-git-proxy" \
    NO_PROXY="*"

RUN echo "builder ALL=NOPASSWD: ALL" > /etc/sudoers.d/builder-nopasswd && \
    chmod 660 /etc/sudoers.d/builder-nopasswd

RUN echo "Defaults env_keep += \"ftp_proxy http_proxy https_proxy no_proxy\"" \
    > /etc/sudoers.d/env_keep && chmod 660 /etc/sudoers.d/env_keep

ENTRYPOINT ["/kas/container-entrypoint"]

RUN apt update && sudo apt install -y zstd liblz4-tool liblz4-dev liblz4-1 -y 

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
WORKDIR /home/vivado/project

RUN sudo mkdir /tftpboot
RUN sudo chown vivado /tftpboot

RUN sudo apt install findutils -y
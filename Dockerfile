FROM ubuntu

# get required file from apt-get
RUN apt-get update
RUN apt-get install -y git g++ libncurses5-dev subversion libssl-dev gawk libxml-parser-perl unzip wget python2.7 automake libtool build-essential

# clone openwrt repository
RUN git clone git://git.openwrt.org/15.05/openwrt.git
RUN cp /openwrt/feeds.conf.default /openwrt/feeds.conf
RUN echo src-git linkit https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git >> /openwrt/feeds.conf
RUN cd /openwrt; ./scripts/feeds update
RUN cd /openwrt; ./scripts/feeds install -a

# get xz command which is not include apt-get repository
# NOTE: 5.2 is not supported for openWRT build, then 5.0.x must be installed
RUN mkdir /home/xz; cd /home/xz; wget http://tukaani.org/xz/xz-5.0.8.tar.gz
RUN cd /home/xz; tar zxvf xz-5.0.8.tar.gz; cd xz-5.0.8; ./autogen.sh; ./configure; make; make install

# make menuconfig and make
RUN cp /openwrt/.config /openwrt/.config.org
COPY .config /openwrt/.config
RUN cd /openwrt; make V=s

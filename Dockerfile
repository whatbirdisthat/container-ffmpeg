FROM ubuntu as buildmachine

RUN apt-get update \
  && apt-get install -y \
  autoconf \
  automake \
  build-essential \
  cmake \
  curl \
  git \
  libass-dev \
  libfreetype6-dev \
  libtheora-dev \
  libtool \
  libvorbis-dev \
  mercurial \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  libsdl2-dev \
  libva-dev \
  libvdpau-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev

#RUN apt install ffmpeg -y

RUN mkdir /root/ffmpeg_sources
RUN mkdir /root/ffmpeg_build

ENV MAKEFLAGS="-j4"

WORKDIR /root/ffmpeg_sources

RUN cd ~/ffmpeg_sources && \
  wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2 && \
  tar xjvf nasm-2.13.01.tar.bz2 && \
  cd nasm-2.13.01 && \
  ./autogen.sh && \
  PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
  make && \
  make install

RUN cd ~/ffmpeg_sources && \
wget -O yasm-1.3.0.tar.gz http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
tar xzvf yasm-1.3.0.tar.gz && \
cd yasm-1.3.0 && \
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make && \
make install

RUN cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 http://git.videolan.org/git/x264 && \
cd x264 && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static && \
PATH="$HOME/bin:$PATH" make && \
make install

RUN cd ~/ffmpeg_sources && \
if cd x265 2> /dev/null; then hg pull && hg update; else hg clone https://bitbucket.org/multicoreware/x265; fi && \
cd x265/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
PATH="$HOME/bin:$PATH" make && \
make install

RUN cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make && \
make install

RUN cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install

RUN cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
PATH="$HOME/bin:$PATH" make && \
make install

RUN cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install

RUN cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2

RUN cd ffmpeg && \
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
#  --enable-libx265 \
  --enable-nonfree && \
  PATH="$HOME/bin:$PATH" make && make install

RUN hash -r

WORKDIR /root/bin

#CMD bash
CMD "/root/bin/ffmpeg"
#CMD [ "echo", "ffmpeg :)" ]

#FROM alpine
#WORKDIR /usr/local/bin
#COPY --from=buildmachine /root/bin/* /usr/local/bin/

#COPY --from=buildmachine /lib/**/* /lib/
#COPY --from=buildmachine /usr/local/lib/**/* /usr/lib/
#COPY --from=buildmachine /usr/lib/**/* /usr/lib/
#COPY --from=buildmachine /lib64/**/* /lib64/

#CMD [ "ffmpeg" ]


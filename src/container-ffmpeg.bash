#!/bin/bash

# Include me in your .bash_profile
#[ -f ~/Containers/container-ffmpeg/bin/container-ffmpeg.bash ] && . ~/Containers/container-ffmpeg/bin/container-ffmpeg.bash

build-ffmpeg() {
  THE_PWD=`pwd`
  cd ~/Containers/container-ffmpeg
  docker build -t whatbirdisthat/ffmpeg .
  cd $THE_PWD
}

ffmpeg() {
  docker run -it --rm \
    -v `pwd`:`pwd` \
    -w `pwd` \
    whatbirdisthat/ffmpeg \
    "$@"
}

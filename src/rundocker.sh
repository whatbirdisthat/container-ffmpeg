docker run -it --rm \
  -v `pwd`:`pwd` \
  -w `pwd` \
  whatbirdisthat/ffmpeg \
  /root/bin/ffmpeg "$@"

#  /root/bin/ffmpeg -i "$1" \
#  -strict -2 \
#  $2


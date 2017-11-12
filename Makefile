item = ffmpeg
container = container-$(item)
image = image-$(item)
version = 1.0

install: uninstall
	ls -s ${PWD}/src/container-ffmpeg.bash ${HOME}/.containers.d/container-ffmpeg
	cp ${PWD}/src/image-ffmpeg.bash ${HOME}/.containers.d/image-ffmpeg

uninstall:
	rm -f ${HOME}/.containers.d/$(container)
	rm -f ${HOME}/.containers.d/$(image)

.PHONY: all clean

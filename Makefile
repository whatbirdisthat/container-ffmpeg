item = ffmpeg
container = container-$(item)
image = image-$(item)
version = 1.0

install: uninstall
	ln -s ${PWD}/src/$(container).bash $${HOME}/.containers.d/$(container)
	cp ${PWD}/src/$(image).bash $${HOME}/.containers.d/$(image)

uninstall:
	rm -f ${HOME}/.containers.d/$(container)
	rm -f ${HOME}/.containers.d/$(image)

run-ffmpeg-large:
	docker run -it --rm whatbirdisthat/$(item)-large bash

run-ffmpeg-small:
	docker run -it --rm whatbirdisthat/$(item)-small ash

ffmpeg-small:
	docker build -t whatbirdisthat/$(item)-small --file ${PWD}/Dockerfile-small .
	docker run -it --rm whatbirdisthat/$(item)-small ash

ffmpeg-large:
	docker build -t whatbirdisthat/$(item)-large --file ${PWD}/Dockerfile .
	docker run -it --rm whatbirdisthat/$(item)-large bash

.PHONY: all clean

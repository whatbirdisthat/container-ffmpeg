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

.PHONY: all clean

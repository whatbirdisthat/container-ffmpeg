item = ffmpeg
container = container-$(item)
image = image-$(item)
version = 1.0

clean:
	rm -f ${HOME}/.containers.d/$(image)
	docker rm $(container) || true
	docker rmi $(image)

define RUN_COMMAND
#!/bin/bash
#$(image)() {
docker run -it --rm         \
-v `pwd`:`pwd` -w `pwd`     \
-h $(image).local  \
$(image) "$$@"
#}
endef

export RUN_COMMAND

install: create-command
	docker build -t "${image}" \
	--squash \
	.

create-command:
	echo "$$RUN_COMMAND" > "/usr/local/bin/${item}"
	chmod u+x "/usr/local/bin/${item}"

uninstall:
	rm /usr/local/bin/${item}

.PHONY: all clean


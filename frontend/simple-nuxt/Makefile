VERSION=$(shell git describe --tags --always)

.PHONY: docker
docker: # Compile and build the docker | 编译并构建 docker 镜像
	pnpm install
	pnpm build
	docker build -f Dockerfile_Multiple_stage -t ${DOCKER_USERNAME}/nuxt-ui:${VERSION} .

.PHONY: docker-not-build
docker-not-build: # Build the docker without compiling | 不编译直接构建镜像
	docker build -f Dockerfile -t ${DOCKER_USERNAME}/nuxt-ui:${VERSION} .

.PHONY: publish-docker
publish-docker: # Publish the docker | 发布镜像
	echo "${DOCKER_PASSWORD}" | docker login --username ${DOCKER_USERNAME} --password-stdin https://${REPO}
	docker push ${DOCKER_USERNAME}/nuxt-ui:${VERSION}

.PHONY: run-docker
run-docker: # Run the docker image | 运行 docker 镜像
	docker volume create nuxtui
	docker run -d --name nuxt-ui -p 3000:3000 -v nuxtui:/etc/nginx ${DOCKER_USERNAME}/nuxt-ui:${VERSION}

.PHONY: help
help: # Show help | 显示帮助
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

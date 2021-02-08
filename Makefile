VERSION ?= $(shell git describe --tags --exact-match 2>/dev/null || echo latest)
DEV_REGISTRY ?= docker.io
IMAGE_PREFIX ?= jianxiaoguo
IMAGE := ${DEV_REGISTRY}/${IMAGE_PREFIX}/go-dev:${VERSION}
PLATFORM ?= linux/amd64,linux/arm64

# scripts are checked *after* build, so use paths inside the container
SHELL_SCRIPTS = /usr/local/bin/test-cover.sh

# dockerized development environment variables
DEV_ENV_PREFIX := docker run --rm
DEV_ENV_CMD := ${DEV_ENV_PREFIX} ${IMAGE}

info:
	@echo "REGISTRY: ${REGISTRY}"
	@echo "VERSION:  ${VERSION}"
	@echo "IMAGE:    ${IMAGE}"

build:
	docker build -t ${IMAGE} rootfs

buildx:
	docker buildx build --platform ${PLATFORM} -t ${IMAGE} rootfs --push

push: build
	docker push ${IMAGE}

test: build
	${DEV_ENV_CMD} shellcheck $(SHELL_SCRIPTS)

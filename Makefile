GO_PACKAGES=$(shell go list ./... | grep -v vendor)
BINARY_NAME=gradetool
REGISTRY?=quay.io
TNF_IMAGE_NAME?=testnetworkfunction/gradetool
IMAGE_TAG?=latest

.PHONY: build

build:
	go build -o $(BINARY_NAME) -v

vet:
	go vet ${GO_PACKAGES}

build-image-local:
	docker build --no-cache \
		-t ${REGISTRY}/${TNF_IMAGE_NAME}:${IMAGE_TAG} \
		-f Dockerfile .

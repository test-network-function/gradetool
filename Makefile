GO_PACKAGES=$(shell go list ./... | grep -v vendor)
BINARY_NAME=gradetool
REGISTRY?=quay.io
TNF_IMAGE_NAME?=testnetworkfunction/gradetool
IMAGE_TAG?=latest
GOLANGCI_VERSION=v1.53.3

.PHONY: build

build:
	go build -o $(BINARY_NAME) -v

vet:
	go vet ${GO_PACKAGES}

build-image-local:
	docker build --no-cache \
		-t ${REGISTRY}/${TNF_IMAGE_NAME}:${IMAGE_TAG} \
		-f Dockerfile .

test:
	go test -v ${GO_PACKAGES}

lint: 
	golangci-lint run --timeout 10m0s

install-lint:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GOLANGCI_VERSION}

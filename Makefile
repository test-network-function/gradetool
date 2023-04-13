GO_PACKAGES=$(shell go list ./... | grep -v vendor)
BINARY_NAME=gradetool

.PHONY: build

build:
	go build -o $(BINARY_NAME) -v

vet:
	go vet ${GO_PACKAGES}

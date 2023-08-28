FROM registry.access.redhat.com/ubi8/ubi:8.8-1032.1692772289 AS build
ENV TNF_SRC_DIR=/usr/tnf

# Install dependencies
RUN \
	mkdir ${TNF_SRC_DIR} \
	&& dnf update --assumeyes --disableplugin=subscription-manager \
	&& dnf install --assumeyes --disableplugin=subscription-manager \
		gcc \
		git \
		jq \
		cmake \
		wget \
	&& dnf clean all --assumeyes --disableplugin=subscription-manager \
	&& rm -rf /var/cache/yum

# Install Go binary and set the PATH 
ENV \
	GO_DL_URL=https://golang.org/dl \
	GO_BIN_TAR=go1.21.0.linux-amd64.tar.gz \
	GOPATH=/root/go
ENV GO_BIN_URL_x86_64=${GO_DL_URL}/${GO_BIN_TAR}
RUN \
	if [ "$(uname -m)" = x86_64 ]; then \
		wget --directory-prefix=${TEMP_DIR} ${GO_BIN_URL_x86_64} --quiet \
		&& rm -rf /usr/local/go \
		&& tar -C /usr/local -xzf ${TEMP_DIR}/${GO_BIN_TAR}; \
	else \
		echo "CPU architecture is not supported." && exit 1; \
	fi
ENV PATH=${PATH}:"/usr/local/go/bin":${GOPATH}/"bin"

# Build the application
COPY . ${TNF_SRC_DIR}
WORKDIR ${TNF_SRC_DIR}
RUN make build

# Run the application
ENTRYPOINT ["/usr/tnf/gradetool"]

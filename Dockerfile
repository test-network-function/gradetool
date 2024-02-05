FROM golang:1.21.6-alpine AS builder
ENV TNF_SRC_DIR=/usr/tnf
RUN apk add --no-cache make~=4.4.1
COPY . ${TNF_SRC_DIR}
WORKDIR ${TNF_SRC_DIR}
RUN make build

# Copy the app into an empty ubi minimal image.
FROM registry.access.redhat.com/ubi8-minimal:8.9-1108.1706691034
ENV TNF_SRC_DIR=/usr/tnf
COPY --from=builder ${TNF_SRC_DIR}/schemas ${TNF_SRC_DIR}/schemas
COPY --from=builder ${TNF_SRC_DIR}/gradetool ${TNF_SRC_DIR}
WORKDIR ${TNF_SRC_DIR}
ENTRYPOINT ["./gradetool"]

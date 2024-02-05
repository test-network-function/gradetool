FROM registry.access.redhat.com/ubi8/go-toolset:1.20.10-10 AS build
ENV TNF_SRC_DIR=/usr/tnf
COPY --chown=1001:1001 . ${TNF_SRC_DIR}
WORKDIR ${TNF_SRC_DIR}
RUN make build

# Copy the app into an empty ubi minimal image.
FROM registry.access.redhat.com/ubi8-minimal:8.9-1108.1706691034
ENV TNF_SRC_DIR=/usr/tnf
COPY --from=build ${TNF_SRC_DIR}/schemas ${TNF_SRC_DIR}/schemas
COPY --from=build ${TNF_SRC_DIR}/gradetool ${TNF_SRC_DIR}
WORKDIR ${TNF_SRC_DIR}
ENTRYPOINT ["./gradetool"]

FROM registry.access.redhat.com/ubi9-minimal:9.9-1795198179@sha256:08d4c70f1baf6537a0728656cf7942d561e74a35916509d205b6519861266352 AS build

RUN microdnf install -y gzip jq tar && microdnf clean all

ADD bin/download-oc-tools.sh .
RUN ./download-oc-tools.sh

FROM registry.access.redhat.com/ubi9-minimal:9.9-1795198179@sha256:08d4c70f1baf6537a0728656cf7942d561e74a35916509d205b6519861266352

LABEL org.opencontainers.image.source="https://github.com/johankok/ubi9-oc-tools" \
      org.opencontainers.image.description="Let's run oc, openshift-install and oc mirror in a container"

RUN microdnf install -y \
      bash-completion \
      jq \
      less \
      nmstate \
      openssh-clients \
      pigz \
      procps-ng \
      rsync \
      tar \
      vim-minimal \
    && microdnf clean all

COPY --from=build /usr/local/bin/* /usr/local/bin/

# Generate shell completion at build time so it matches the bundled binaries
RUN oc completion bash > /etc/bash_completion.d/oc \
 && openshift-install completion bash > /etc/bash_completion.d/openshift-install

ENV PAGER=less

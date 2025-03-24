ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

LABEL name="drycc-go-dev"

ENV GO_VERSION=1.24.1
ENV GOLANGCI_LINT_VERSION=v1.61.0

# This is a huge one-liner to optimize the Container image layer.
# We disable source repos to speed up apt-get update.
RUN export DEBIAN_FRONTEND=noninteractive \
  && install-packages \
    lsb-release \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    gettext \
    jq \
    libffi-dev \
    libssl-dev \
    man-db \
    mercurial \
    net-tools \
    netcat-openbsd \
    openssh-client \
    procps \
    rsync \
    ruby \
    unzip \
    util-linux \
    vim \
    wget \
    zip \
    shellcheck \
    etcd-server \
  && UPX_VERSION=4.2.4 \
  && OS_ARCH=$(dpkg --print-architecture) \
  && wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${OS_ARCH}_linux.tar.xz \
  && tar -Jxvf upx-${UPX_VERSION}-${OS_ARCH}_linux.tar.xz \
  && cp upx-${UPX_VERSION}-${OS_ARCH}_linux/upx /usr/local/bin \
  && rm -rf upx-${UPX_VERSION}-${OS_ARCH}_linux* \
  && install-stack go $GO_VERSION && . init-stack \
  && curl -o /usr/local/bin/kubectl \
    -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" \
  && chmod +x /usr/local/bin/kubectl \
  && curl -SL https://cli.codecov.io/latest/$([ $(dpkg --print-architecture) == "arm64" ] && echo linux-arm64 || echo linux)/codecov -o /usr/local/bin/codecov \
  && chmod +x /usr/local/bin/codecov \
  && go env -w GO111MODULE=on \
  && go install github.com/AlekSi/gocov-xml@latest \
  && go install github.com/axw/gocov/gocov@latest \
  && go install github.com/mitchellh/gox@latest \
  && go install github.com/mgechev/revive@latest \
  && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $GOLANGCI_LINT_VERSION \
  && mkdir -p /var/lib/shared/{overlay-images,overlay-layers} \
  && touch /var/lib/shared/{overlay-images/images.lock,overlay-layers/layers.lock} \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc

WORKDIR /opt/drycc/go

COPY . /

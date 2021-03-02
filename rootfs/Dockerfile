FROM docker.io/library/golang:1.15

LABEL name="drycc-go-dev"

ENV ENVTPL_VERSION=v1.0.0
ENV GOLANGCI_LINT_VERSION=v1.29.0

# This is a huge one-liner to optimize the Docker image layer.
# We disable source repos to speed up apt-get update.
RUN export DEBIAN_FRONTEND=noninteractive \
  #  podman source list
  && echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list \
  && echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
  && curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | apt-key add - \
  && apt-get update \
  && apt-get -y -t buster-backports install libseccomp2 \
  && apt-get install -y podman \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install -y --no-install-recommends \
    lsb-release \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git-core \
    jq \
    libffi-dev \
    libssl-dev \
    man \
    mercurial \
    net-tools \
    netcat \
    openssh-client \
    procps \
    rsync \
    ruby \
    unzip \
    upx \
    util-linux \
    vim \
    wget \
    zip \
    shellcheck \
    etcd \
  && curl -o /usr/local/bin/kubectl \
    -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" \
  && chmod +x /usr/local/bin/kubectl \
  && go env -w GO111MODULE=on \
  && go get -u -v \
    github.com/AlekSi/gocov-xml \
    github.com/axw/gocov/gocov \
    github.com/mitchellh/gox \
    golang.org/x/lint \
  && git clone --dept 1 -b $ENVTPL_VERSION https://github.com/subfuzion/envtpl $GOPATH/src/github.com/subfuzion/envtpl \
  && cd $GOPATH/src/github.com/subfuzion/envtpl \
  && export GO111MODULE=on \
  && CGO_ENABLED=0 go build \
        -ldflags "-X main.AppVersionMetadata=$(date -u +%s)" \
        -a -installsuffix cgo -o /bin/envtpl ./cmd/envtpl/. \
  && curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $GOPATH/bin $GOLANGCI_LINT_VERSION \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc

WORKDIR /go

COPY . /

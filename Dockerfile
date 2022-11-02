FROM ubuntu:kinetic-20220830

ENV PYTHONUNBUFFERED=1 \
  DEBIAN_FRONTEND=noninteractive \
  GOPATH=/opt/app-root/go \
  GO_VERSION=1.17.8 \
  CDXGEN_VERSION=4.0.23 \
  PATH=${PATH}:${GOPATH}/bin:/usr/local/go/bin:

USER root

# base packages
RUN mkdir -p /opt/sl-cli && apt update -y \
  && apt install --no-install-recommends -y jq curl wget zip unzip openjdk-8-jdk \
  build-essential python3.8 python3.8-dev python3-setuptools python3-pip python3.8-venv git maven gradle

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt install -y nodejs

# yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update && apt install -y yarn

# cdxgen
RUN npm install -g @appthreat/cdxgen@${CDXGEN_VERSION}

# Go
RUN curl -LO "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && rm go${GO_VERSION}.linux-amd64.tar.gz

RUN rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

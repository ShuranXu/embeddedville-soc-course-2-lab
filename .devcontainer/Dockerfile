FROM ubuntu@sha256:224a1869083a311ef3f13648a154ba79832fbef6364d31493642ca03082da254

LABEL org.opencontainers.image.source="https://github.com/ShuranXu/embeddedville-soc-course-2-lab" \
      org.opencontainers.image.description="Pinned EmbeddedVille SoC Course 2 lab toolchain" \
      org.opencontainers.image.licenses="LicenseRef-Course-Use"

ARG DEBIAN_FRONTEND=noninteractive
ARG GNU_ARM_VERSION=15.3.rel1
ARG GNU_ARM_SHA256=563bebb2b97d53382b956d6ee1fe61e2cae26699901417234a37df505ef9b5fa
ARG VERILATOR_VERSION=5.050
ARG VERILATOR_SHA256=ec6723f30c1798b1fbbbed97364f09c431fb4875577c314f37240e99b60a4a04
ARG RENODE_VERSION=1.16.1
ARG RENODE_SHA256=00e113cdbd0f5354cf2f64bbe3f5a070d8958409542fca66e45ac97d982938c0
ARG PYTHON_SERIES=3.12

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf bison build-essential ca-certificates cmake curl flex git help2man \
    libfl2 libfl-dev libglib2.0-0 libgoogle-perftools-dev ninja-build perl python3 \
    python3-pip unzip xz-utils zip zlib1g-dev && \
    test "$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')" = "${PYTHON_SERIES}" && \
    useradd -m -s /bin/bash vscode && rm -rf /var/lib/apt/lists/*

RUN curl -fL "https://gitlab.arm.com/api/v4/projects/tooling%2Fgnu-toolchains-for-arm/packages/generic/gnu-toolchain/${GNU_ARM_VERSION}/arm-gnu-toolchain-${GNU_ARM_VERSION}-x86_64-arm-none-eabi.tar.xz" -o /tmp/gnu.tar.xz && \
    echo "${GNU_ARM_SHA256}  /tmp/gnu.tar.xz" | sha256sum -c - && \
    mkdir -p /opt/gnu-arm && tar -xJf /tmp/gnu.tar.xz -C /opt/gnu-arm --strip-components=1 && rm /tmp/gnu.tar.xz

RUN curl -fL "https://github.com/verilator/verilator/archive/refs/tags/v${VERILATOR_VERSION}.tar.gz" -o /tmp/verilator.tar.gz && \
    echo "${VERILATOR_SHA256}  /tmp/verilator.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/verilator && tar -xzf /tmp/verilator.tar.gz -C /tmp/verilator --strip-components=1 && \
    cd /tmp/verilator && autoconf && ./configure --prefix=/opt/verilator && make -j2 && make install && \
    rm -rf /tmp/verilator /tmp/verilator.tar.gz

RUN curl -fL "https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/renode-${RENODE_VERSION}.linux-portable-dotnet.tar.gz" -o /tmp/renode.tar.gz && \
    echo "${RENODE_SHA256}  /tmp/renode.tar.gz" | sha256sum -c - && \
    mkdir -p /opt/renode && tar -xzf /tmp/renode.tar.gz -C /opt/renode --strip-components=1 && rm /tmp/renode.tar.gz && \
    ln -s /opt/renode/renode /usr/local/bin/renode

ENV PATH="/opt/gnu-arm/bin:/opt/verilator/bin:${PATH}" \
    EMBEDDEDVILLE_STARTER_VERSION="course-2-v1.0.0"
WORKDIR /workspaces/embeddedville-soc-course-2-lab

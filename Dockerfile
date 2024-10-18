# Stage 1: Risc0 Development Container
FROM ghcr.io/anagrambuild/solana:latest
ARG TARGETARCH

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    binutils \
    clang \
    cmake \ 
    gnupg2 \
    libssl-dev \
    make \
    ninja-build \ 
    perl \ 
    pkg-config \
    protobuf-c-compiler \
    && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER=solana
ARG SOLANA=1.18.22
ENV CARGO_HOME=/usr/local/cargo
ENV RUSTUP_HOME=/usr/local/rustup
ENV PATH=${PATH}:/usr/local/cargo/bin:/go/bin:/home/solana/.local/share/solana/install/releases/${SOLANA}/bin

RUN cargo install cargo-binstall && \
    yes | cargo binstall cargo-risczero && \
    if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "linux/amd64" ]; then \
        cargo risczero install; \
    else \
        echo "building risc0 toolchain"; \
        cargo risczero build-toolchain; \
    fi

LABEL \
    org.label-schema.name="risc0" \
    org.label-schema.description="Risc0 Development Container" \
    org.label-schema.url="https://github.com/anagrambuild/risc0" \
    org.label-schema.vcs-url="git@github.com/anagrambuild/risc0.git" \
    org.label-schema.vendor="anagram.xyz" \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Risc0 Development Container"

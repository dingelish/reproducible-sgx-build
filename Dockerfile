FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

#
# we can use intel provided nix environment
# https://github.com/intel/linux-sgx/tree/a59e51e223da75cf7cc37b3de2c12aa26ba51f55/linux/reproducibility

# here we hand craft a ubuntu based reproducible environment

# Initial docker image can be fixed. Bit of trivial. Optional: pinning all the versions and remove unnecessary packages.
RUN apt update && apt install -y autoconf automake bison build-essential cmake curl dpkg-dev expect flex gcc-8 gdb git git-core gnupg kmod libboost-system-dev libboost-thread-dev libcurl4-openssl-dev libiptcdata0-dev libjsoncpp-dev liblog4cpp5-dev libprotobuf-c0-dev libprotobuf-dev libssl-dev libtool libxml2-dev ocaml ocamlbuild pkg-config protobuf-compiler python texinfo uuid-dev vim wget dkms gnupg2 apt-transport-https software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Set up binutils for side channel attack mitigation
# TODO: hard code the SHA256 check against the following value
# 89be60f5736ef9387921a28cf8ceaddb29debea5e14969dfd21c97f546a4071e  as.ld.objdump.r4.tar.gz
RUN cd /root && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/SHA256SUM_prebuilt_2.15.1.cfg && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/as.ld.objdump.r4.tar.gz && \
    grep as.ld.objdump.r4.tar.gz SHA256SUM_prebuilt_2.15.1.cfg | shasum -c && \
    tar xzf as.ld.objdump.r4.tar.gz && \
    cp -r external/toolset/$BINUTILS_DIST/* /usr/bin/ && \
    rm -rf ./external ./as.ld.objdump.r4.tar.gz

# Set up Intel SGX SDK
# TODO: hard code the SHA256 check against the following value
# 6cdeb005d6db5bf2a2713b8e3fc1691200d4ace6e8adf60bf4629703b6685f95  distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin
RUN cd /root && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/SHA256SUM_linux_2.15.1.cfg && \
    wget -P distro/ubuntu18.04-server/ https://download.01.org/intel-sgx/sgx-linux/2.15.1/distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    grep distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin SHA256SUM_linux_2.15.1.cfg | shasum -c && \
    chmod a+x distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    echo -e 'no\n/opt' | distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    echo 'source /opt/sgxsdk/environment' >> /root/.bashrc && \
    rm -rf ./distro

# Install Rust
# nightly-2021-11-01 toolchain manifest is https://static.rust-lang.org/dist/2021-11-01/channel-rust-nightly.toml
# Copy a tarball to the container is ok
# Path: ~/.rustup ~/.cargo
RUN cd /root && \
    wget https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init && \
    echo "3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338  ./rustup-init" > checksum && \
    shasum -c checksum && \
    chmod +x ./rustup-init && \
    echo '1' | /root/rustup-init --default-toolchain nightly-2021-11-01 && \
    echo 'source /root/.cargo/env' >> /root/.bashrc && \
    /root/.cargo/bin/rustup component add rust-src rls rust-analysis clippy rustfmt && \
    echo 'source /root/.cargo/env' >> /root/.bashrc


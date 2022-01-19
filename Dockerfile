FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Initial docker image can be fixed. Bit of trivial. Optional: pinning all the versions and remove unnecessary packages.
RUN apt update && apt install -y autoconf automake bison build-essential cmake curl dpkg-dev expect flex gcc-8 gdb git git-core gnupg kmod libboost-system-dev libboost-thread-dev libcurl4-openssl-dev libiptcdata0-dev libjsoncpp-dev liblog4cpp5-dev libprotobuf-c0-dev libprotobuf-dev libssl-dev libtool libxml2-dev ocaml ocamlbuild pkg-config protobuf-compiler python texinfo uuid-dev vim wget dkms gnupg2 apt-transport-https software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Set up binutils for side channel attack mitigation
# SHA256
RUN cd /root && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/SHA256SUM_prebuilt_2.15.1.cfg && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/as.ld.objdump.r4.tar.gz && \
    grep as.ld.objdump.r4.tar.gz SHA256SUM_prebuilt_2.15.1.cfg | shasum -c && \
    tar xzf as.ld.objdump.r4.tar.gz && \
    cp -r external/toolset/$BINUTILS_DIST/* /usr/bin/ && \
    rm -rf ./external ./as.ld.objdump.r4.tar.gz

# Set up Intel SGX SDK
RUN cd /root && \
    wget https://download.01.org/intel-sgx/sgx-linux/2.15.1/SHA256SUM_linux_2.15.1.cfg && \
    wget -P distro/ubuntu18.04-server/ https://download.01.org/intel-sgx/sgx-linux/2.15.1/distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    grep distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin SHA256SUM_linux_2.15.1.cfg | shasum -c && \
    chmod a+x distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    echo -e 'no\n/opt' | distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.15.101.1.bin && \
    echo 'source /opt/sgxsdk/environment' >> /root/.bashrc && \
    rm -rf ./distro

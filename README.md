# Reproducible build reference

## vendor rust-sgx-sdk

in this repo, rust-sgx-sdk is maintained by a git submodule

## vendor source codes

in the enclave directory, run `cargo vendor` and add corresponding lines to enclave/.cargo/config to let rustc use the vendor directory

## patch debug symbols

use cc_wrapper.sh and rustc_wrapper.sh to replace CC and RUSTC. these scripts help normalize some path which is hard coded in debug symbol. PROJECT_ROOT, BUILD_ROOT, RUST_SGX_SDK_ROOT will be replaced by PROJECT_SYMLINKS. see these shell scripts for details.

```
export PROJECT_ROOT=$(pwd)/enclave
export BUILD_ROOT=$(pwd)/enclave
export RUST_SGX_SDK_ROOT=$(pwd)/teaclave-sgx-sdk
export PROJECT_SYMLINKS=/tmp

export CC=$(pwd)/cc_wrapper.sh
export RUSTC=$(pwd)/rustc_wrapper.sh
```

## configure rustcflags

since the target triple is x86_64-linux-unknown-linux-gnu, it inherits default llvm flags. but we need a few more. put these in .cargo/config

lvi flags help with side channel attack mitigation, but it slows down the enclave.

```toml
[build]
rustflags = ["-C", "target-feature=+rdrnd,+rdseed,+lvi-cfi,+lvi-load-hardening"]
```

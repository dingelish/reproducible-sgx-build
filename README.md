# Reproducible build reference

## vendor rust-sgx-sdk

in this repo, rust-sgx-sdk is maintained by a git submodule

## vendor source codes

in the enclave directory, run `cargo vendor` and add corresponding lines to enclave/.cargo/config to let rustc use the vendor directory

## patch debug symbols

use cc_wrapper.sh and rustc_wrapper.sh to replace CC and RUSTC

```
export CC=cc_wrapper.sh
export RUSTC=rustc_wrapper.sh
```

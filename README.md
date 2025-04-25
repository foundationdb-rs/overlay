# Overlay [![CI](https://github.com/foundationdb-rs/overlay/actions/workflows/ci.yml/badge.svg)](https://github.com/foundationdb-rs/overlay/actions/workflows/ci.yml)
A Nix overlay to download elements for FoundationDB from GitHub.

## Packages provided

* libfdb_c.x86_64.so 
  * 7.1
  * 7.2
  * 7.3
* fdbserver
  * 7.3.63

## How-to use it

Please see the [example folder](./examples/) to see examples on how to use and override the flake.

## Test it

```bash
nix flake check .
```
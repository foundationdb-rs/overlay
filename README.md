# FoundationDB Nix Overlay [![CI](https://github.com/foundationdb-rs/overlay/actions/workflows/ci.yml/badge.svg)](https://github.com/foundationdb-rs/overlay/actions/workflows/ci.yml)

A Nix overlay to easily use FoundationDB binaries in your Nix projects.

## Packages Provided

This overlay provides the following packages:

*   `libfdb`: The FoundationDB C client library.
    *   Versions: 7.1, 7.2, 7.3, 7.4
*   `fdbserver`: The FoundationDB server.
    *   Versions: 7.3, 7.4
*   `fdbcli`: The FoundationDB command-line interface.
    *   Versions: 7.1, 7.3, 7.4

## How to Use

To use this overlay, add it to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fdb-overlay.url = "github:foundationdb-rs/overlay";
  };

  outputs = { self, nixpkgs, flake-utils, fdb-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fdb-overlay.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.libfdb pkgs.fdbcli ];
        };
      }
    );
}
```

This example creates a development shell with the `libfdb` and `fdbcli` packages.

For more advanced usage, such as using specific versions or overriding packages, please refer to the [examples](./examples/) directory.

## Testing

To check that the overlay is working correctly, you can run the following command:

```bash
nix flake check .
```
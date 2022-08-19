{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay.url = github:oxalica/rust-overlay;
    fdb-overlay.url = path:./../..;
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, fdb-overlay, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlay fdb-overlay.overlays.default ];
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rust-bin.stable.latest.default
            pkg-config
            libfdb
          ];
          FDB_LIB_PATH = "${pkgs.libfdb}/include";
        };
      }
    );
}

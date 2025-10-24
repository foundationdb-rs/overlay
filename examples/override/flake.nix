{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fdb-overlay.url = "path:./../..";
  };

  outputs = { nixpkgs, flake-utils, fdb-overlay, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fdb-overlay.overlays.default ];
        };
        libfdb7149 = pkgs.libfdb71.overrideAttrs (finalAttrs: previousAttrs: {
          version = "7.1.49";
          sha256 = "7464326281f8d3d6bad2e4fe85f494e84cd54a842fbed237c1fcbe3f1387f9d1";
        });
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ libfdb7149 ];
          FDB_LIB_PATH = "${libfdb7149}/include";
        };
      }
    );
}

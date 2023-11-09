{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    fdb-overlay.url = path:./../..;
  };

  outputs = { nixpkgs, flake-utils, fdb-overlay, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fdb-overlay.overlays.default ];
        };
        libfdb730 = pkgs.libfdb.overrideAttrs (finalAttrs: previousAttrs: {
          version = "7.3.27";
          sha256 = "9b8db407ae5898d03e882a39839d5b3873fb41081f08b8e87bd067562d20f36b";
        });
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ libfdb730 ];
          FDB_LIB_PATH = "${libfdb730}/include";
        };
      }
    );
}

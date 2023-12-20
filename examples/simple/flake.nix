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
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ libfdb ];
          FDB_LIB_PATH = "${pkgs.libfdb}/include";
        };
      }
    );
}

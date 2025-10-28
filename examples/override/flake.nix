{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fdb-overlay.url = "path:./../..";
  };

  outputs =
    {
      nixpkgs,
      fdb-overlay,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ fdb-overlay.overlays.default ];
      };

      libfdb7149 = pkgs.libfdb71.overrideAttrs (
        finalAttrs: previousAttrs: {
          version = "7.1.49";
          sha256 = "7464326281f8d3d6bad2e4fe85f494e84cd54a842fbed237c1fcbe3f1387f9d1";
        }
      );
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        nativeBuildInputs = [ libfdb7149 ];
        FDB_LIB_PATH = "${libfdb7149}/include";
      };
    };
}

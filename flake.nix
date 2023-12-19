{
  description = "A flake to setup the client part of FoundationDB";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlays.default = final: prev: {
        # avoid breaking current users
        libfdb = final.callPackage ./pkgs/libfdb/libfdb_71.nix { };
        libfdb71 = final.callPackage ./pkgs/libfdb/libfdb_71.nix { };
        libfdb72 = final.callPackage ./pkgs/libfdb/libfdb_72.nix { };
        libfdb73 = final.callPackage ./pkgs/libfdb/libfdb_73.nix { };
      };
    };
}

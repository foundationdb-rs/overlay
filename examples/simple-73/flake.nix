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
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ libfdb73 ];
        FDB_LIB_PATH = "${pkgs.libfdb73}/include";
      };
    };
}

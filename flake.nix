{
  description = "A flake to setup the client part and server for FoundationDB";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      pkgsFor = system: import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
    in
    {
      overlays.default = final: prev: {
        # Keep default libfdb to 7.1 to avoid breaking current user
        libfdb = final.callPackage ./pkgs/libfdb/libfdb_71.nix { };
        libfdb71 = final.callPackage ./pkgs/libfdb/libfdb_71.nix { };
        libfdb72 = final.callPackage ./pkgs/libfdb/libfdb_72.nix { };
        libfdb73 = final.callPackage ./pkgs/libfdb/libfdb_73.nix { };
        libfdb74 = final.callPackage ./pkgs/libfdb/libfdb_74.nix { };

        # Add fdbserver
        fdbserver71 = final.callPackage ./pkgs/fdbserver/fdbserver_71.nix { };
        fdbserver73 = final.callPackage ./pkgs/fdbserver/fdbserver_73.nix { };
        fdbserver74 = final.callPackage ./pkgs/fdbserver/fdbserver_74.nix { };

        fdbcli71 = final.callPackage ./pkgs/fdbcli/fdbcli_71.nix { };
        fdbcli73 = final.callPackage ./pkgs/fdbcli/fdbcli_73.nix { };
        fdbcli74 = final.callPackage ./pkgs/fdbcli/fdbcli_74.nix { };
      };

      # Add checks
      checks = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          checkLib = pkg: name: pkgs.runCommand name { buildInputs = [ pkg ]; } ''
            if [ ! -f "${pkg}/include/libfdb_c.so" ]; then
              echo "Error: ${pkg}/include/libfdb_c.so not found!"
              exit 1
            fi
            touch $out
          '';
          # Override check needs specific logic
          libfdb7149_override = pkgs.libfdb71.overrideAttrs (finalAttrs: previousAttrs: {
            version = "7.1.49";
            sha256 = "7464326281f8d3d6bad2e4fe85f494e84cd54a842fbed237c1fcbe3f1387f9d1";
          });
        in
        {
          # Original fdbserver check
          fdbserver-help-71 = pkgs.runCommand "fdbserver-help-check-71" { buildInputs = [ pkgs.fdbserver71 ]; } ''
            ${pkgs.fdbserver71}/bin/fdbserver --help > $out
          '';

          fdbserver-help-73 = pkgs.runCommand "fdbserver-help-check-73" { buildInputs = [ pkgs.fdbserver73 ]; } ''
            ${pkgs.fdbserver73}/bin/fdbserver --help > $out
          '';

          fdbserver-help-74 = pkgs.runCommand "fdbserver-help-check-74" { buildInputs = [ pkgs.fdbserver74 ]; } ''
            ${pkgs.fdbserver74}/bin/fdbserver --help > $out
          '';

          # fdbcli checks
          fdbcli-help-71 = pkgs.runCommand "fdbcli-help-check-71" { buildInputs = [ pkgs.fdbcli71 ]; } ''
            ${pkgs.fdbcli71}/bin/fdbcli --help > $out
          '';

          fdbcli-help-73 = pkgs.runCommand "fdbcli-help-check-73" { buildInputs = [ pkgs.fdbcli73 ]; } ''
            ${pkgs.fdbcli73}/bin/fdbcli --help > $out
          '';

          fdbcli-help-74 = pkgs.runCommand "fdbcli-help-check-74" { buildInputs = [ pkgs.fdbcli74 ]; } ''
            ${pkgs.fdbcli74}/bin/fdbcli --help > $out
          '';

          # Example Checks
          check-simple = checkLib pkgs.libfdb "check-simple"; # Checks default (libfdb71)
          check-simple-71 = checkLib pkgs.libfdb71 "check-simple-71";
          check-simple-72 = checkLib pkgs.libfdb72 "check-simple-72";
          check-simple-73 = checkLib pkgs.libfdb73 "check-simple-73";
          check-simple-74 = checkLib pkgs.libfdb74 "check-simple-74";
          check-override = checkLib libfdb7149_override "check-override"; # Checks the overridden 7.1.49

          # VM Tests
          standalone-vm-test = pkgs.callPackage ./tests/standalone.nix { };
          cluster-vm-test = pkgs.callPackage ./tests/cluster.nix { };
        }
      );
    };
}

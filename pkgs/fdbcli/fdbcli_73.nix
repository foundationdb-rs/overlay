{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.3.67";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "ed3fd295fba57596a8974e3cdb5d28806a78d55e14abc366a8dbf52a723354e0";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

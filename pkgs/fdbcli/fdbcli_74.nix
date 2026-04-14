{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.4.6";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "b0e47b9bd03addc745ba7ee283fa7a0c5fd7bfe2fa9d99bfb63692369d5659c6";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

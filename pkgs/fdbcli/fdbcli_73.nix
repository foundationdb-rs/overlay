{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.3.69";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "c679051460b7c6f630213f443c523b8881403d4d8d9ce397aa584e12fed65888";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

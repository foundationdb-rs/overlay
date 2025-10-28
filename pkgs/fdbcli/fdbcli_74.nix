{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.4.5";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "bd267011f2795f0f00ab635f301bca3a3be86a61bbf4299ebef139a03e8da601";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.1.61";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "8007495367ef2e5de1bf93eb94cf8886fd375494c37e75aa333e9259c28ebfa6";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

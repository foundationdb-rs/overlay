{ stdenv
, autoPatchelfHook
, fetchurl
, lib
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.1.59";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "2fd11165c08fb89d5ac62349fa8b94529aaf7f6be5ade606cd5394a64a781763";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

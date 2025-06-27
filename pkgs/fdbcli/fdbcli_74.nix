{ stdenv
, autoPatchelfHook
, fetchurl
, lib
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbcli";
  version = "7.4.3";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbcli.x86_64";
    sha256 = "c5ce9c68ac0b2bbb2f2273017a4e1ce90285e7d3ea62cedc00984deee83a9106";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbcli
    chmod +x $out/bin/fdbcli
  '';
})

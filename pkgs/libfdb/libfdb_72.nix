{ stdenv
, autoPatchelfHook
, fetchurl
, lib
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.2.8";
  sha256 = "425c68f254333a8b12cc99a0d0df02992b5beb6db0302ba9819e317d7bcc813d";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/libfdb_c.x86_64.so";
    sha256 = "${finalAttrs.sha256}";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = [
    ''
      mkdir -p $out/include
      cp $src $out/include/libfdb_c.so
      chmod 555 $out/include/libfdb_c.so
    ''
  ];
})

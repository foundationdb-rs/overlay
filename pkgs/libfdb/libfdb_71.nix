{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.1.61";
  sha256 = "f3cd884f6a4463305220eb2160f910e0dbcd5109dfc90acd427a37a1d09ca9cc";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/libfdb_c.x86_64.so";
    sha256 = "${finalAttrs.sha256}";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  unpackPhase = ":";

  installPhase = [
    ''
      mkdir -p $out/include
      cp $src $out/include/libfdb_c.so
      chmod 555 $out/include/libfdb_c.so
    ''
  ];
})

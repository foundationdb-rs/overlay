{ stdenv
, autoPatchelfHook
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.1.19";
  sha256 = "51b2bc6d3e60d22ed0e393ed814026d1e529acc6a3a644405788f2749f4dd54d";

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

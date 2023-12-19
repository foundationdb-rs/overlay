{ stdenv
, autoPatchelfHook
, fetchurl
, lib
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.3.27";
  sha256 = "9b8db407ae5898d03e882a39839d5b3873fb41081f08b8e87bd067562d20f36b";

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

{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.4.5";
  sha256 = "f3eb95d649fc9a2193cfa22d6871ad01c03b23c341f2b6e8e4668a0f5609a1f4";

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
